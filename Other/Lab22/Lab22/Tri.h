//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#pragma once
#include "Point.h"

class Tri 
{
private:
	Point mCorners[3];
public:
	// Constructor w/ parameters
	Tri(double x0, double y0,
		double x1, double y1,
		double x2, double y2);

	// Getters/setter
	Point getCorner(unsigned int index);
	void set(double x0, double y0,
		double x1, double y1,
		double x2, double y2);
	// Calculate the area of the triangle
	double calcArea();
    
    // Calculate perimeter
    double calcPerimeter();
};
