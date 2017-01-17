//  Puja Patel
//  ITP 165, Fall 2015
//  Homework 7
//  pujadpat@usc.edu

#include <iostream>
#include <cstdlib>
#include <string>

//created Card structure with 2 variables
struct Card
{
    int rank;
    std::string suit;
};

//  Function: cardToString
//  Purpose: returns the string of a card
//  Parameters: 1 card
//  Returns: string containing name of the card
std::string cardToString(Card& card)
{
    std::string name;
    if (card.rank <= 10) //if rank is less than 10 use number
    {
        name += std::to_string(card.rank);
    }
    else //if rank is more than 10 convert to name
    {
        if (card.rank==11)
            name += "Jack";
        else if (card.rank==12)
            name += "Queen";
        else if (card.rank==13)
            name += "King";
        else if (card.rank==14)
            name += "Ace";
    }
    name += " of ";
    name += card.suit;
    return name;
}

//  Function: makeCard
//  Purpose: creates a variable to type card
//  Parameters: an int for rank and an std::string for suit
//  Returns: Card
Card makeCard(int rank, std::string suit)
{
    Card newCard;
    newCard.rank = rank;
    newCard.suit = suit;
    return newCard;
}

//  Function: getRandRank
//  Purpose: generates a random number between 2 and 14
//  Parameters: none
//  Returns: int rank
int getRandRank()
{
    int rank = std::rand()%12+0; //selects a random number between 0 and 12
    return rank+2;
}

//  Function: getRandSuit
//  Purpose: generates a random suit
//  Parameters: none
//  Returns: std::string suit
std::string getRandSuit()
{
    std::string suit;
    int numSuit = std::rand()%4+1; //selects a random number between 1 and 4
    if (numSuit == 1)              //assigns that number to a suit
    {
        suit="Spades";
    }
    else if (numSuit == 2)
    {
        suit="Diamonds";
    }
    else if (numSuit == 3)
    {
        suit="Hearts";
    }
    else if (numSuit == 4)
    {
        suit="Clubs";
    }
    return suit;
}

//  Function: isEqual
//  Purpose: compares the ranks of 2 cards
//  Parameters: 2 card variables
//  Returns: true if ranks are equal
bool isEqual (Card card1, Card card2)
{
    if (card1.rank == card2.rank)
    {
        return true;
    }
    else
    {
        return false;
    }
}

//  Function: isLess
//  Purpose: compares the ranks of 2 cards
//  Parameters: 2 card variables
//  Returns: true if rank of card1 is less than card2
bool isLess (Card card1, Card card2)
{
    if (card1.rank < card2.rank)
    {
        return true;
    }
    else
    {
        return false;
    }
}

//  Function: isGreater
//  Purpose: compares the ranks of 2 cards
//  Parameters: 2 card variables
//  Returns: true if rank of card1 is greater than card2
bool isGreater (Card card1, Card card2)
{
    if (card1.rank > card2.rank)
    {
        return true;
    }
    else
    {
        return false;
    }
}


int main()
{
    std::srand(std::time(0));
    
    //initialize variables
    std::string p1Name = "Player 1";
    std::string p2Name = "Player 2";
    int p1score = 0;
    int p2score = 0;
    Card p1card;
    Card p2card;
    int counter = 1;
    bool playAgain = true;
    std::string userResponse;
    
    std::cout << "Welcome to the world champion High-card tournament finals!" <<std::endl<< "It's a match between " << p1Name << " and " << p2Name << "!";
    do //game inside of do-while loop
    {
        std::cout << std::endl << "They're starting round " << counter << "." <<std::endl;
        std::cout << "The players are shuffling..." <<std::endl;
        
        p1card = makeCard (getRandRank(), getRandSuit()); //randomly selects cards for 2 players
        p2card = makeCard (getRandRank(), getRandSuit());
        
        if (isGreater(p1card, p2card)) //checks if card 1 is greater than card 2
        {
            std::cout << p1Name << "'s " << cardToString(p1card) << " beat " << p2Name << "'s " << cardToString(p2card) << "!" << std::endl;
            p1score+=1; //updates score
            std::cout << "The score is..." << std::endl;
            std::cout << p1Name << ": " << p1score << ", " << p2Name << ": " << p2score << std::endl;
            std::cout << "Should the 2 players go again (y/n)? "; //checks if user wants to continue
            std::cin >> userResponse;
        }
        else if (isLess(p1card, p2card)) //checks if card 2 is greater than card 1
        {
            std::cout << p2Name << "'s " << cardToString(p2card) << " beat " << p1Name << "'s " << cardToString(p1card) << "!" << std::endl;
            p2score+=1; //updates score
            std::cout << "The score is..." << std::endl;
            std::cout << p1Name << ": " << p1score << ", " << p2Name << ": " << p2score << std::endl;
            std::cout << "Should the 2 players go again (y/n)? "; //checks if user wants to continue
            std::cin >> userResponse;
        }
        else if (isEqual(p1card, p2card)) //checks if cards are equal
        {
            std::cout << p1Name << " drew a " << cardToString(p1card) << " to match " << p2Name << "'s " <<cardToString(p2card) << "!" <<std::endl << "It's a draw!" << std::endl;
            std::cout << "The score is..." << std::endl;
            std::cout << p1Name << ": " << p1score << ", " << p2Name << ": " << p2score <<std::endl;
            std::cout << "Should the 2 players go again (y/n)? "; //checks if user wants to continue
            std::cin >> userResponse;
        }
        
        if (userResponse == "n" || userResponse == "N") //if user does not want to continue
        {
            playAgain = false; //sets boolean to false
            std::cout << std::endl << "Well that's all we have time for tonight."<< std::endl << "Thanks for tuning in!";
        }
        
        counter+=1; //updates number of games played
    }
    while (playAgain == true); //game will continue while playAgain is equal to true
    
    return 0;
}
