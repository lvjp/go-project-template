// Copyright (C) 2019-2020 VERDOÏA Laurent
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

package protocol

import "fmt"

// Operation define which operation server should execute.
type Operation uint8

// Operation which server should implement.
const (
	Addition Operation = iota + 1
	Subtraction
	Multiplication
	Division
)

// ParseOperation convert an input string to an Operation.
// An error is returned if conversion failed.
func ParseOperation(input string) (operation Operation, err error) {
	switch input {
	case "+":
		operation = Addition
	case "-":
		operation = Subtraction
	case "*":
		operation = Multiplication
	case "/":
		operation = Division
	default:
		err = fmt.Errorf("unknow operation: '%s'", input)
	}

	return
}

// Request permit to ask computation to the server.
type Request struct {
	Operator     Operation
	LeftOperand  float64
	RightOperand float64
}

// Response hold the computation response.
type Response struct {
	Result float64
}
