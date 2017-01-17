// Shapes.h
#pragma once

class Shape {
public:
	virtual double calcArea() = 0;
    virtual void print() = 0;
};

// Point, Circle, Rect, Tri below

class Point {
private:
	double mX;
	double mY;
public:
	// Default constructor
	Point();
	// Constructor with parameters
	Point(double x, double y);
	// Getters/setter
	double getX();
	double getY();
	void set(double x, double y);
};

// In Shapes.h, after Point prototype
class Circle : public Shape {
private:
	Point mCenter;
	double mRadius;
public:
	// Constructor with parameters
	// (Default constructor not allowed!)
	Circle(double x, double y, double rad);
	// Getters/setter
	Point getCenter();
	double getRadius();
	void set(double x, double y, double rad);
	// Calculates area of circle
	double calcArea();
    void print();
};

// In Shapes.h, after Circle prototype
class Rect : public Shape {
private:
	Point mBotLeft;
	Point mTopRight;
public:
	// Constructor w/ parameters
	Rect(double botX, double botY,
		double topX, double topY);
	// Getters/setter
	Point getBotLeft();
	Point getTopRight();
	void set(double botX, double botY,
		double topX, double topY);
	// Calculate area of rectangle
	double calcArea();
    void print();
};

// In Shapes.h, after Rect prototype
class Tri : public Shape {
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
    void print();
};
