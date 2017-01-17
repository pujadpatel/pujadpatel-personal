//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 24
//  pujadpat@usc.edu

#include "Shapes.h"
#include <iostream>
#include <vector>

int main() {
    int option = -1;
    std::vector<Shape*> shapeList;
    while (option != 0)
    {
        std::cout << "Pick a shape (1, 2, or 3):";
        std::cin >> option;
        
        Shape* myShape = nullptr;
        
        if (option == 1) {
            std::cout << "Making a circle!" << std::endl;
            shapeList.push_back(new Circle(0, 0, 5));
        }
        else if (option == 2) {
            std::cout << "Making a rectangle!" << std::endl;
            shapeList.push_back(new Rect(0, 0, 5, 5));
        }
        else if (option == 3){
            std::cout << "Making a triangle!" << std::endl;
            shapeList.push_back(new Tri(0, 0, 0, 5, 5, 5));
        }
        else if (option == 0)
        {
            std::cout << "Quitting" << std::endl;
        }
        else
        {
            std::cout << "invalid option!" << std::endl;
        }
    }
    
    for (int i = 0; i <shapeList.size() ; i++)
    {
        shapeList[i]->print();
        std::cout << "Area is: " << shapeList[i]->calcArea() << std::endl;
        delete shapeList[i];
    }
    shapeList.clear();
    
    return 0;
}
