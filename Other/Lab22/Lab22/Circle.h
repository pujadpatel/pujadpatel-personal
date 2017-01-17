//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#pragma once
#include "Point.h"

class Circle {
private:
	Point mCenter;
	double mRadius;
public:
	// Constructor with parameters (Default constructor not allowed!)
	Circle(double x, double y, double rad);

	// Getters/setter
	Point getCenter();
	double getRadius();
	void set(double x, double y, double rad);

	// Calculates area of circle
	double calcArea();
    
    //Calculates perimeter
    double calcPerimeter();
};


