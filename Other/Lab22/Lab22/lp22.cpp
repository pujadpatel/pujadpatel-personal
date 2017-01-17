//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

// main.cpp
#include "Circle.h"
#include "Rect.h"
#include "Tri.h"
#include <iostream>

int main() {
	std::cout << "Pick a shape (1, 2, or 3):";
	int option = 0;
	std::cin >> option;

	if (option == 1) {
		std::cout << "Making a circle!" << std::endl;
		Circle* myCircle = new Circle(0, 0, 5);
		std::cout << "Area is: " << myCircle->calcArea() << std::endl;
        std::cout << "Perimeter is: " << myCircle->calcPerimeter() << std::endl;
	}
	else if (option == 2) {
		std::cout << "Making a rectangle!" << std::endl;
		Rect* myRect = new Rect(0, 0, 5, 5);
		std::cout << "Area is: " << myRect->calcArea() << std::endl;
        std::cout << "Perimeter is: " << myRect->calcPerimeter() << std::endl;
	}
	else {
		std::cout << "Making a triangle!" << std::endl;
		Tri* myTri = new Tri(0, 0, 0, 5, 5, 5);
		std::cout << "Area is: " << myTri->calcArea() << std::endl;
        std::cout << "Perimeter is: " << myTri->calcPerimeter() << std::endl;
	}

	return 0;
}

