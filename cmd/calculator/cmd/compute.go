// Copyright (C) 2019 VERDOÏA Laurent
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

package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"gitlab.com/lvjp/go-project-template/internal/pkg/logic"
	"gitlab.com/lvjp/go-project-template/pkg/protocol"
	"strconv"
)

var computeCmd = &cobra.Command{
	Use:                   "compute <operator> <operand> <operand>",
	Short:                 "Locally calculator all four basic operations",
	DisableFlagParsing:    true,
	DisableFlagsInUseLine: true,
	ValidArgs: []string{
		"pif",
		"paf",
		"pouf",
	},
	Args: func(cmd *cobra.Command, args []string) error {
		if err := cobra.ExactArgs(3)(cmd, args); err != nil {
			return err
		}

		if _, err := protocol.ParseOperation(args[0]); err != nil {
			return err
		}

		if _, err := strconv.ParseFloat(args[1], 64); err != nil {
			return fmt.Errorf("operand '%s' conversion error: %w", args[1], err)
		}

		if _, err := strconv.ParseFloat(args[2], 64); err != nil {
			return fmt.Errorf("operand '%s' conversion error: %w", args[2], err)
		}

		return nil
	},
	RunE: func(cmd *cobra.Command, args []string) error {
		var request protocol.Request
		request.Operator, _ = protocol.ParseOperation(args[0])
		request.LeftOperand, _ = strconv.ParseFloat(args[1], 64)
		request.RightOperand, _ = strconv.ParseFloat(args[2], 64)

		response, err := logic.ComputeMessage(&request)
		if err != nil {
			return err
		}

		fmt.Println(response.Result)
		return nil
	},
}

func init() {
	rootCmd.AddCommand(computeCmd)
}
