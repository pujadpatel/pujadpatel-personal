//  Puja Pattel
//  ITP 165, Fall 2015
//  Lab 22
//  pujadpat@usc.edu

#include "Circle.h"
#include <iostream>

// Constructor
Circle::Circle(double x, double y, double rad) {
	set(x, y, rad);
}

// Getters/setters
Point Circle::getCenter() {
	return mCenter;
}

double Circle::getRadius() {
	return mRadius;
}

void Circle::set(double x, double y, double rad) {
	mCenter.set(x, y);
	mRadius = rad;
}

// Calculate area of circle
double Circle::calcArea() {
	return mRadius * mRadius * 3.141592;
}

// Calculate perimeter
double Circle::calcPerimeter()
{
    return 2 * mRadius * 3.141592;
}

