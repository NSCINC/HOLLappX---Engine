local ffi = require("ffi")
local openssl = require("openssl")

-- Tamanho do buffer e do digest
local bufferSize = 213
local digestSize = 32  -- SHA-256 tem um digest de 32 bytes

-- Blake2bfMessageDigest representa um digest de mensagem Blake2bf
local Blake2bfMessageDigest = {}
Blake2bfMessageDigest.__index = Blake2bfMessageDigest

-- Cria uma nova instância de Blake2bfMessageDigest
function Blake2bfMessageDigest.new()
    local self = setmetatable({}, Blake2bfMessageDigest)
    self.buffer = ffi.new("uint8_t[?]", bufferSize)
    self.bufferSize = 0
    self.digest = ffi.new("uint8_t[?]", digestSize)
    return self
end

-- Retorna o digest da mensagem
function Blake2bfMessageDigest:Digest()
    if self.bufferSize ~= bufferSize then
        error(string.format("Buffer not filled with %d bytes", bufferSize))
    end

    local sha256 = openssl.digest.get("sha256")
    local hash = sha256:final(self.buffer, self.bufferSize)
    return hash
end

-- Atualiza o digest com um novo valor
function Blake2bfMessageDigest:Update(value)
    if self.bufferSize >= bufferSize then
        error("Buffer overflow")
    end
    self.buffer[self.bufferSize] = value
    self.bufferSize = self.bufferSize + 1
end

-- Atualiza o digest com um array de bytes
function Blake2bfMessageDigest:UpdateBytes(bytes)
    for i = 1, #bytes do
        self:Update(bytes[i])
    end
end

-- Atualiza o digest com um inteiro em big-endian
function Blake2bfMessageDigest:UpdateBigEndianInt(value)
    local buf = ffi.new("uint8_t[4]")
    ffi.cast("uint32_t*", buf)[0] = ffi.cast("uint32_t", value)
    buf[0], buf[1], buf[2], buf[3] = buf[3], buf[2], buf[1], buf[0]  -- Conversão para big-endian
    self:UpdateBytes(ffi.string(buf, 4))
end

-- Reseta o buffer do digest
function Blake2bfMessageDigest:Reset()
    self.bufferSize = 0
end

-- Testes
local function test()
    local messageDigest = Blake2bfMessageDigest.new()

    -- Atualizar o digest com 213 bytes
    for i = 1, bufferSize do
        messageDigest:Update(0)
    end

    local digest = messageDigest:Digest()
    print(string.format("%x", ffi.string(digest, digestSize):gsub(".", function(c) return string.format("%02x", string.byte(c)) end)))

    -- Mais testes aqui...
end

test()
