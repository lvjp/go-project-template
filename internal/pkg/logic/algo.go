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

package logic

import (
	"errors"
	"fmt"
	"gitlab.com/lvjp/go-project-template/pkg/protocol"
)

// ComputeMessage process the given request and return a ready to send response.
func ComputeMessage(request *protocol.Request) (response *protocol.Response, err error) {
	if request == nil {
		err = errors.New("nil request")
		return
	}

	var tmp float64

	switch request.Operator {
	case protocol.Addition:
		tmp = request.LeftOperand + request.RightOperand
	case protocol.Subtraction:
		tmp = request.LeftOperand - request.RightOperand
	case protocol.Multiplication:
		tmp = request.LeftOperand * request.RightOperand
	case protocol.Division:
		tmp = request.LeftOperand / request.RightOperand
	default:
		err = fmt.Errorf("unsupported operator: %d", request.Operator)
		return
	}

	response = &protocol.Response{
		Result: tmp,
	}
	return
}
