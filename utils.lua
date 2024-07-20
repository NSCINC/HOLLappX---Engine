-- Load Lua.live library
local holoFi = require("holoFi")

-- Check if tensor A is sparse
local function is_sparse(A)
    if type(A) == "table" and A.layout == "sparse_coo" then
        return true
    end
    error("expected Tensor but got " .. type(A))
end

-- Return the floating point dtype of tensor A
local function get_floating_dtype(A)
    local dtype = A.dtype
    if dtype == "float16" or dtype == "float32" or dtype == "float64" then
        return dtype
    end
    return "float32"
end

-- Multiply two matrices
local function matmul(A, B)
    if A == nil then
        return B
    end
    if is_sparse(A) then
        return holoFi.sparse.mm(A, B)
    end
    return holoFi.matmul(A, B)
end

-- Return conjugate of tensor A
local function conjugate(A)
    if A.dtype == "complex" then
        return holoFi.conj(A)
    end
    return A
end

-- Return transpose of a matrix
local function transpose(A)
    local ndim = #A.shape
    return holoFi.transpose(A, ndim - 1, ndim - 2)
end

-- Return transpose conjugate of a matrix
local function transjugate(A)
    return conjugate(transpose(A))
end

-- Return bilinear form of matrices: X^T A Y
local function bform(X, A, Y)
    return matmul(transpose(X), matmul(A, Y))
end

-- Return quadratic form S^T A S
local function qform(A, S)
    return bform(S, A, S)
end

-- Return orthogonal basis of A columns
local function basis(A)
    local Q, _ = holoFi.qr(A)
    return Q
end

-- Return eigenpairs of A with specified ordering
local function symeig(A, largest)
    largest = largest or false
    local E, Z = holoFi.eigh(A, "U")
    if largest then
        E = holoFi.flip(E, -1)
        Z = holoFi.flip(Z, -1)
    end
    return E, Z
end

-- Deprecated functions
local function matrix_rank()
    error("This function was deprecated since version 1.9 and is now removed. Please use the `torch.linalg.matrix_rank` function instead.")
end

local function solve(A, B)
    error("This function was deprecated since version 1.9 and is now removed. Use `torch.linalg.solve` instead.")
end

local function lstsq(A, B)
    error("This function was deprecated since version 1.9 and is now removed. Use `torch.linalg.lstsq` instead.")
end

local function eig(A, eigenvectors)
    error("This function was deprecated since version 1.9 and is now removed. Use `torch.linalg.eig` instead.")
end
