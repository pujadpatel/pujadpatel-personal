//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 05
//  pujadpat@usc.edu

#include "tictactoe.h"
#include <iostream>

int main()
{
    bool playAgain = true; //bool to repeat game
    do{
        //variable setup
        char winner;
        bool turn;
        bool inputValid;
        int userInput;
        int numTurns;
        char answer;
        char board[9] = {'1','2','3','4','5','6','7','8','9'};
        
        PrintBoard(board);
        //initialize variables
        winner = WinnerIfAny(board);
        turn = true; //true for player X and false for player O
        numTurns = 0;
        
        //Part 2: User input for player moves
        while (winner == 'N') //game loop
        {
            std::cout << "Where would you like to go? Input an available number: ";
            std::cin >> userInput;
            inputValid = false;
            while (inputValid == false) //checks if input is valid
            {
                if (IsValidMove(board, userInput-1)==true) //if number between 1 and 9
                {
                    if (board[userInput-1] == 'O' || board[userInput-1] == 'X') //if there is already a piece there, move is invalid
                    {
                        inputValid = false;
                        std::cout << "Invalid move. Pick again: ";
                        std::cin >> userInput;
                    }
                    else
                    {
                        inputValid = true; //space is clear
                    }
                }
                else
                {
                    std::cout << "Invalid move. Pick again: ";
                    std::cin >> userInput;
                }
            }
            
            //Part 3: Output user's move
            //determines whose turn it is now
            if (numTurns%2==0) //true for X and false for O
            {
                turn = true;
            }
            else
                turn = false;
            
            if (turn == true)
            {
                board[userInput-1]='X'; //puts x on space
            }
            else if (turn == false)
            {
                board[userInput-1]='O'; //puts o on space
            }
            PrintBoard(board);
            winner = WinnerIfAny(board);
            if (numTurns == 8 && winner == 'N') //checks if there is a stalemate
            {
                winner = 'S';
            }
            numTurns++; //iterates the number of turns
            
            //Present the winner
            if (winner != 'N') //if winner exists or stalemate
            {
                if (winner == 'X')
                {
                    std::cout<< "Player X Wins!"<<std::endl;
                }
                else if (winner == 'O')
                {
                    std::cout<< "Player O Wins!"<<std::endl;
                }
                else if (winner == 'S')
                {
                    std::cout<< "Stalemate!"<<std::endl;
                }
                std::cout<< "Would you like to play again? (y/n)" <<std::endl;
                std::cin >> answer;
                if (answer == 'n' || answer == 'N') //checks play again
                {
                    playAgain = false;
                }
            }
        }
    }
    while (playAgain == true); //loops through game again
    
    return 0;
    
}

