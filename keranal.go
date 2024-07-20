package main

import (
	"fmt"
	"sync"
)

// LoginSecurityKernel struct contém as variáveis e métodos para controle de login
type LoginSecurityKernel struct{}

var (
	loggedInUsers         = make(map[string]int)
	maxParticipantsPerUnit = 7
	maxUnits              = 300
	mutex                 sync.Mutex // Mutex para operações seguras em loggedInUsers
)

// login tenta autenticar o usuário com o username e password fornecidos
func (l *LoginSecurityKernel) login(username, password string) bool {
	// Lógica de autenticação
	isAuthenticated := l.authenticateUser(username, password)

	// Se autenticado com sucesso, registra o usuário logado
	if isAuthenticated {
		mutex.Lock()
		loggedInUsers[username]++
		mutex.Unlock()
	}

	return isAuthenticated
}

// logout realiza o logout do usuário especificado
func (l *LoginSecurityKernel) logout(username string) bool {
	mutex.Lock()
	defer mutex.Unlock()

	// Remove o usuário da lista de usuários logados ao fazer logout
	if count, ok := loggedInUsers[username]; ok && count > 0 {
		loggedInUsers[username]--
		if loggedInUsers[username] == 0 {
			delete(loggedInUsers, username)
		}
		return true
	}
	return false
}

// tokenClosed verifica se o número de unidades ativas é menor ou igual a 300
func (l *LoginSecurityKernel) tokenClosed() bool {
	mutex.Lock()
	defer mutex.Unlock()

	return len(loggedInUsers) <= maxUnits
}

// canJoinUnit verifica se o número de participantes na unidade atual é menor que 7
func (l *LoginSecurityKernel) canJoinUnit(username string) bool {
	mutex.Lock()
	defer mutex.Unlock()

	return loggedInUsers[username] < maxParticipantsPerUnit
}

// authenticateUser simula a lógica de autenticação
func (l *LoginSecurityKernel) authenticateUser(username, password string) bool {
	// Lógica de autenticação - a ser implementada de acordo com requisitos específicos
	return true // Simulação de autenticação bem-sucedida
}

func main() {
	// Exemplo de uso do modelo de autenticação
	username := "user123"
	password := "password123"

	var kernel LoginSecurityKernel

	if kernel.login(username, password) {
		fmt.Println("Login successful")
		if kernel.canJoinUnit(username) {
			fmt.Println("User can join unit")
		} else {
			fmt.Println("Unit is full")
		}
	} else {
		fmt.Println("Login failed")
	}

	// Simulação de logout
	if kernel.logout(username) {
		fmt.Println("Logout successful")
	} else {
		fmt.Println("Logout failed")
	}

	// Verifica se o token está fechado
	if kernel.tokenClosed() {
		fmt.Println("Token is closed")
	} else {
		fmt.Println("Token is still open")
	}
}
