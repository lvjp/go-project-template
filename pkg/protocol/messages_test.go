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

import "testing"

func TestParseOperation(t *testing.T) {
	testCases := []struct {
		Input    string
		Expected Operation
	}{
		{"+", Addition},
		{"-", Subtraction},
		{"*", Multiplication},
		{"/", Division},
	}

	for i, testCase := range testCases {
		actual, err := ParseOperation(testCase.Input)
		if err != nil {
			t.Errorf("test %d end up with error: %v", i, err)
			continue
		}

		if actual != testCase.Expected {
			t.Errorf("test %d unexpected result: %+v", i, actual)
			continue
		}
	}
}

func TestParseOperation_errors(t *testing.T) {
	testCases := []struct {
		Input string
	}{
		{""},
		{"@"},
	}

	for i, testCase := range testCases {
		_, err := ParseOperation(testCase.Input)
		if err == nil {
			t.Errorf("test %d error not returned", i)
			continue
		}
	}
}
