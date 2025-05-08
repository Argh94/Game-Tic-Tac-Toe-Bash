#!/bin/bash
# Simple X and O game For Termux

# Initialize game board
board=(. . . . . . . . .)

# Defining function to print the board
function print_board {
    echo ""
    echo " ${board[0]} | ${board[1]} | ${board[2]} "
    echo "---+---+---"
    echo " ${board[3]} | ${board[4]} | ${board[5]} "
    echo "---+---+---"
    echo " ${board[6]} | ${board[7]} | ${board[8]} "
    echo ""
}

# Defining function to check for a win
function check_win {
    local player=$1
    # Check rows, columns, and diagonals
    win_conditions=("0 1 2" "3 4 5" "6 7 8"  # Rows
                    "0 3 6" "1 4 7" "2 5 8"  # Columns
                    "0 4 8" "2 4 6")         # Diagonals
    for condition in "${win_conditions[@]}"; do
        read i j k <<< "$condition"
        if [[ ${board[$i]} == $player && ${board[$j]} == $player && ${board[$k]} == $player ]]; then
            echo "Player $player wins!"
            return 0
        fi
    done
    return 1
}

# Defining function to check for a draw
function check_draw {
    for space in "${board[@]}"; do
        if [[ $space == "." ]]; then
            return 1
        fi
    done
    echo "The game is a draw."
    return 0
}

# Function to reset the board
function reset_board {
    board=(. . . . . . . . .)
}

# Function to validate input
function validate_input {
    local choice=$1
    if [[ ! $choice =~ ^[1-9]$ ]]; then
        echo "Please enter a number between 1 and 9."
        return 1
    fi
    local index=$((choice - 1))
    if [[ ${board[$index]} != "." ]]; then
        echo "That space is already taken. Try again."
        return 1
    fi
    return 0
}

# Main game loop
while true; do
    current_player="X"
    reset_board
    while true; do
        print_board
        echo "Player $current_player, choose a space (1-9):"
        read choice
        if ! validate_input "$choice"; then
            continue
        fi

        # Place the player's mark
        board[$((choice - 1))]=$current_player

        # Check for win or draw
        if check_win "$current_player"; then
            print_board
            break
        fi
        if check_draw; then
            print_board
            break
        fi

        # Switch player
        if [[ $current_player == "X" ]]; then
            current_player="O"
        else
            current_player="X"
        fi
    done

    # Ask to play again
    echo "Would you like to play again? (y/n)"
    read play_again
    if [[ $play_again != "y" && $play_again != "Y" ]]; then
        echo "Thanks for playing!"
        break
    fi
done
