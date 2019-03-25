import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      buttons[r][c] = new MSButton (r, c);
    }
  }

  setBombs();
}

public void setBombs()
{
  //your code
  while (bombs.size() < NUM_BOMBS)
  {
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if (! bombs.contains(buttons[row][col]) )
      bombs.add(buttons[row][col]);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
    displayWinningMessage();
}

public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      if (!buttons[r][c].isClicked() == true && !bombs.contains(buttons[r][c]))
      {
        return false;
      }
    }
  }
  return true;
}

public void displayLosingMessage()
{
  //your code here
  for (int r = 0; r < NUM_ROWS; r++)
  {
    for (int c = 0; c < NUM_COLS; c++)
    {
      if (!buttons[r][c].isClicked() && bombs.contains(buttons[r][c]))
      {
        buttons[r][c].marked = false;
        buttons[r][c].clicked = true;
        buttons[10][8].setLabel("L");
        buttons[10][9].setLabel("o");
        buttons[10][10].setLabel("s");
        buttons[10][11].setLabel("e");
        buttons[10][12].setLabel("r");
        buttons[10][13].setLabel("!");
      }
    }
  }
}

public void displayWinningMessage()
{
  //your code here
  buttons[10][8].setLabel("Y");
  buttons[10][9].setLabel("o");
  buttons[10][10].setLabel("u");
  buttons[10][11].setLabel("W");
  buttons[10][12].setLabel("o");
  buttons[10][13].setLabel("n");
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    clicked = true;
    //your code here
    if (mouseButton == RIGHT)
    {
      marked = !marked; 
      if (marked == false)
        clicked = false;
    } else if (bombs.contains(this))
      displayLosingMessage();

    else if (countBombs(r, c) > 0)
      label = "" + countBombs(r, c);

    else
    {
      for (int i = r - 1; i <= r + 1; i++)
      {
        for (int j = c - 1; j <= c + 1; j++)
        {
          if (isValid(i, j) && !bombs.contains(buttons[i][j]) && buttons[i][j] != this && buttons[i][j].isClicked() == false) 
            buttons[i][j].mousePressed();
        }
      }
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(255, 0, 0);
    else if (clicked)
      fill( 200 );
    else 
    fill( 100 );

    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }

  public void setLabel(String newLabel)
  {
    label = newLabel;
  }

  public boolean isValid(int r, int c)
  {
    //your code here: check valid location
    if (r>=0 && r<20 && c>=0 && c<20)
      return true;

    return false;
  }

  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    //your code here: count 8 neighboring bombs
    for (int r=row-1; r<=row+1; r++)
    {
      for (int c=col-1; c<=col+1; c++)
      {
        if (isValid(row, col)==true && bombs.contains(buttons[r][c]))
          numBombs +=1;
      }
    }
    return numBombs;
  }
}
