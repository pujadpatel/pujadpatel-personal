#include "Point.h"
//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#include <cmath>
#include <iostream>

Point::Point()
{
	mXCoord = 0.0;
	mYCoord = 0.0;
}

Point::Point(double x, double y)
{
	mXCoord = x;
	mYCoord = y;
}

void Point::setX(double inX)
{
	mXCoord = inX;
}

void Point::setY(double inY)
{
	mYCoord = inY;
}

void Point::set(double inX, double inY)
{
	mXCoord = inX;
	mYCoord = inY;
}

double Point::getX()
{
	return mXCoord;
}

double Point::getY()
{
	return mYCoord;
}

void Point::print()
{
	std::cout << "(" << mXCoord << "," << mYCoord << ")";
}

double Point::getDistance(Point p2)
{
    double distance = sqrt(pow((getX()-p2.getX()), 2)+(pow((getY()-p2.getY()),2)));
    return distance;
}



