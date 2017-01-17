//TIC-TAC-TOE
//pgrey Fall 2015

#include <iostream>
#define GRID_SIZE 9

//Function: PrintBoard
//Purpose: to print the 3x3 grid game board for Tic-Tac-Toe, including player moves
//Parameters: the character array that contains the game's moves
//Return: none
void PrintBoard(char move[])
{
    std::cout << " " << move[0] << " | " << move[1] << " | " << move[2] << " " << std::endl;
    std::cout << "------------" << std::endl;
    std::cout << " " << move[3] << " | " << move[4] << " | " << move[5] << " " << std::endl;
    std::cout << "------------" << std::endl;
    std::cout << " " << move[6] << " | " << move[7] << " | " << move[8] << " " << std::endl;
}

//Function: IsValidMove
//Purpose: to validate if a player may make a move in the attempted spot on the game board
//Parameters: the charcter array storing player moves, the index of the player's next and attempted move in array
//Return: true if player may make a move, false if spot is already taken
bool IsValidMove(char move[], int index)
{
    if (!(move[index] >= '1' && move[index] <= '9'))
    {
        return false;
    }
    else
    {
        return true;
    }
}

//Function: WinnerIfAny
//Purpose: to determine who is the current winner (if any)
//Parameters: the character array that contains the game's moves
//Return: a char symbolizing who is the current winner: either X or O to show a player has one, or N if no one has yet won the game
char WinnerIfAny(char move[])
{
    unsigned int j = 0;
    for (unsigned int i = 0; i < GRID_SIZE; i+=3)
    {
        if (move[i] == move[i + 1] && move[i] == move[i + 2])
        {
            return move[i];
        }
        else if (move[j] == move[j + 3] && move[j] == move[j + 6])
        {
            return move[j];
        }
        else if (move[0] == move[4] && move[0] == move[8])
        {
            return move[0];
        }
        else if (move[2] == move[4] && move[2] == move[6])
        {
            return move[2];
        }
        j++;
    }
    return 'N';
}