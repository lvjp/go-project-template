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
	"gitlab.com/lvjp/go-project-template/pkg/protocol"
	"math"
	"testing"
)

func TestComputeMessage(t *testing.T) {
	testCases := []struct {
		Operation protocol.Operation
		Left      float64
		Right     float64
		Result    float64
	}{
		{protocol.Addition, 1, 3, 4},
		{protocol.Subtraction, 2.5, 1.75, 0.75},
		{protocol.Multiplication, 6, 7, 42},
		{protocol.Division, 4, 2, 2},
	}

	for i, testCase := range testCases {
		request := &protocol.Request{
			Operator:     testCase.Operation,
			LeftOperand:  testCase.Left,
			RightOperand: testCase.Right,
		}
		actual, err := ComputeMessage(request)
		if err != nil {
			t.Errorf("test %d give an unexpected error: %s", i, err)
			continue
		}

		if actual.Result != testCase.Result {
			t.Errorf("test %d give an unexpected result: %+v", i, actual)
			continue
		}
	}
}

func TestComputeMessage_errors(t *testing.T) {
	testCases := []struct {
		Request *protocol.Request
	}{
		{nil},
		{&protocol.Request{Operator: 0}},
		{&protocol.Request{Operator: math.MaxUint8}},
	}

	for i, testCase := range testCases {
		response, err := ComputeMessage(testCase.Request)
		if err == nil {
			t.Errorf("test %d error not returned", i)
			continue
		}

		if response != nil {
			t.Errorf("response generated even if error was returned")
			continue
		}
	}
}
