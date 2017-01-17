//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#pragma once
#include "Point.h"

class Rect 
{
private:
	Point mBotLeft;
	Point mTopRight;
public:
	// Constructor w/ parameters
	Rect(double botX, double botY, double topX, double topY);

	// Getters/setter
	Point getBotLeft();
	Point getTopRight();
	void set(double botX, double botY, double topX, double topY);

	// Calculate area of rectangle
	double calcArea();
    
    // Calculate perimeter
    double calcPerimeter();
};


