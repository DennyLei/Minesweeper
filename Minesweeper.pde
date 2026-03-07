import de.bezier.guido.*;
public static int NUM_ROWS = 10;
public static int NUM_COLS = 10;
public static int NUM_MINES = 10;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int r=0;r<NUM_ROWS;r++){
      for(int c=0;c<NUM_COLS;c++){
        buttons[r][c] = new MSButton(r, c);
      }
    }
    
    setMines();
    
}
public void setMines()
{   while(mines.size()<NUM_MINES){
      int r = (int)(Math.random()*NUM_ROWS);
      int c = (int)(Math.random()*NUM_COLS);
      if(!mines.contains(buttons[r][c]))
        mines.add(buttons[r][c]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public void keyPressed()
{
    if(key == 'r') NUM_ROWS++;
    if(key == 'f' && NUM_ROWS > 2) NUM_ROWS--;

    if(key == 'c') NUM_COLS++;
    if(key == 'v' && NUM_COLS > 2) NUM_COLS--;

    if(key == 'm') NUM_MINES++;
    if(key == 'n' && NUM_MINES > 1) NUM_MINES--;
}
public boolean isWon()
{
    for(int r=0;r<NUM_ROWS;r++){
        for(int c=0;c<NUM_COLS;c++){
            if(!mines.contains(buttons[r][c]) && buttons[r][c].clicked == false)
                return false;
        }
    }
    return true;
}
public void displayLosingMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("you lose");
}
public void displayWinningMessage()
{
    buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("you win");
}
public boolean isValid(int r, int c)
{
    if(r>=0 && r<NUM_ROWS && c>=0 && c<NUM_COLS)return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r=-1;r<2;r++)
      for(int c=-1;c<2;c++){
        if(row+r==row&&col+c==col)numMines+=0;
        else if(isValid(row+r,col+c)==true&&mines.contains(buttons[row+r][col+c]))numMines++;}
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true; 
        if(mouseButton == RIGHT)
          if(buttons[myRow][myCol].isFlagged()==true)buttons[myRow][myCol].flagged=false;
          else{ buttons[myRow][myCol].flagged=true;buttons[myRow][myCol].clicked=false;}
        else if(mines.contains(buttons[myRow][myCol]))displayLosingMessage();
        else if(countMines(myRow,myCol)>0)buttons[myRow][myCol].setLabel(countMines(myRow,myCol));
        else for(int r=-1;r<2;r++)
                for(int c=-1;c<2;c++){
                  if(isValid(myRow+r,myCol+c)==true&&buttons[myRow+r][myCol+c].clicked==false)buttons[myRow+r][myCol+c].mousePressed();
                }
                
           
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
