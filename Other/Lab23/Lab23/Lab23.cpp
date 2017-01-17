//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 23
//  pujadpat@usc.edu

#include "Candy.h"
#include "SoftCandy.h"

int main()
{
    Candy* myCandy = new Candy ("Candy", 100,100,5.00);
    myCandy->display();
    delete myCandy;
    
    myCandy = new SoftCandy("Soft", 5,50,2.50,5);
    myCandy->display();
    
    return 0;
}
