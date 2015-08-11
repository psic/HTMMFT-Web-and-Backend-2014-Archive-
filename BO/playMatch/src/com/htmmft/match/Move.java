package com.htmmft.match;

public class Move {
	
	private int x;
	private int y;
	private char type;
	private int time;
	
	public Move( int x, int y, int time) {
		this.x=x;
		this.y=y;
		this.time =time;
	}
	public Move( int x, int y, int time, char move) {
		this.x=x;
		this.y=y;
		this.time =time;
		type = move;
	}
	/**
	 * @return the x
	 */
	public int getX() {
		return x;
	}
	/**
	 * @param x the x to set
	 */
	public void setX(int x) {
		this.x = x;
	}
	/**
	 * @return the y
	 */
	public int getY() {
		return y;
	}
	/**
	 * @param y the y to set
	 */
	public void setY(int y) {
		this.y = y;
	}
	/**
	 * @return the type
	 */
	public char getType() {
		return type;
	}
	/**
	 * @param type the type to set
	 */
	public void setType(char type) {
		this.type = type;
	}
	/**
	 * @return the time
	 */
	public int getTime() {
		return time;
	}
	/**
	 * @param time the time to set
	 */
	public void setTime(int time) {
		this.time = time;
	}

}
