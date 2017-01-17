//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#pragma once

class Point
{
public:
	// Constructors
	Point();
	Point(double x, double y);

	// Getters
	double getX();
	double getY();

	// Setters
	void setX(double inX);
	void setY(double inY);
	void set(double inX, double inY);

	// Display
	void print();
    
    // Other functions
    double getDistance(Point p2);

private:
	double mXCoord;
	double mYCoord;
};
