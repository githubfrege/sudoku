using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace Seppuku
{
    public class SudokuCell : Button
    {
        public int Value { get; set; }
        public bool IsLocked { get; set; }
        public  int X { get; set; }
        public int Y { get; set; }
        public int ClickIndex { get; set; }

        public void Clear()
        {
            this.Text = string.Empty;
            this.Value = 0;
        }
    }
    public partial class Form1 : Form
    {
        Random rand = new Random();
        SudokuCell[,] cells = new SudokuCell[9, 9];
        public Form1()
        {
            InitializeComponent();
            createCells();
            findValueForNextCell(0, -1);
            showRandomValuesHints(45);
        }

        public List<SudokuCell> generateBlockList(int xBounds, int yBounds)
        {
            List<SudokuCell> blockList = new List<SudokuCell>();
            for (int x = xBounds; x < xBounds + 3; x++)
            {
                for (int y = yBounds; y < yBounds + 3; y++)
                {
                    blockList.Add(cells[x,y]);

                }
            }
            return blockList;
        }
        public void setValue(SudokuCell cell, int value)
        {
            cell.Text = value == 0 ? String.Empty :  value.ToString();
            cell.Value = value;
        }

        
        public bool findValueForNextCell(int x, int y)
        {
            incrementor:
                if (++y > 8) //if end of column
                {
                    y = 0; //check next column
                    if (++x > 8)
                    {
                        return true;  //exit and be true if all clells have been checked
                    }
                }
            if (cells[x, y].IsLocked)
            {
                goto incrementor;
            }

            int value = 0;
            List<int> availableNums = Enumerable.Range(1, 9).ToList();
            do
            {
                if (availableNums.Count < 1)
                {
                    cells[x, y].Value = 0;
                    return false; //if false go back
                }
                value = availableNums[rand.Next(0, availableNums.Count)];
                cells[x, y].Value = value;
                availableNums.Remove(value);
            } while (!isValidNumber(value, x, y) || !findValueForNextCell(x, y)); //check next
            return true;
        }
        
        
        private void showRandomValuesHints(int hintsCount)
        {
            for (int i = 0; i < hintsCount; i++)
            {
                int rX = rand.Next(9);
                int rY = rand.Next(9);
                cells[rX, rY].Text = cells[rX, rY].Value.ToString();
                cells[rX, rY].IsLocked = true;
            }
        }
        private void showAllNumbers()
        {
            foreach (SudokuCell cell in cells)
            {
                cell.Text = cell.Value.ToString();
            }
        }
        public bool isValidNumber(int value, int x, int y)
        {
            for (int i = 0; i < 9; i++)
            {
                if (i != y && cells[x,i].Value == value)
                {
                    return false;
                }
                if (i != x && cells[i, y].Value == value)
                {
                    return false;
                }
            }
            List<SudokuCell> blockList = generateBlockList((x/3)*3, (y/3) *3);
            foreach (SudokuCell cell in blockList)
            {
                if (cell != cells[x,y] && cell.Value == value)
                {
                    return false;
                }
            }

            return true;
        }
      
        public void createCells()
        {
            for (int y = 0; y < 9; y++)
            {
                for (int x = 0; x < 9; x++)
                {
                    SudokuCell cell = new SudokuCell()
                    {
                        Size = new Size(40, 40),
                        Location = new Point(x * 40, y * 40),
                        BackColor = ((x / 3) + (y / 3)) % 2 == 0 ? SystemColors.Control : Color.LightGray,
                        X =  x,
                        Y = y,
                };
                    cells[x, y] = cell;
                    this.Controls.Add(cell);
                    setValue(cell, 0);
                    cells[x, y].Click += cell_Click;
                }
            }
            
        }
       
        private void cell_Click(object sender, EventArgs e)
        {
            SudokuCell cell = sender as SudokuCell;
            if (cell.IsLocked)
            {
                return;
            }
           if (cell.ClickIndex < 10){
                if (cell.ClickIndex == 0)
                {
                    cell.Text = String.Empty;
                }
                else
                {
                    cell.Text = cell.ClickIndex.ToString();
                }
            }
            else
            {
                cell.ClickIndex = 0;
                cell.Text = cell.ClickIndex.ToString();

            }
            cell.ClickIndex++;
        }

        private void btnCheckInput_Click(object sender, EventArgs e)
        {
            /*List<SudokuCell> wrongCells = new List<SudokuCell>();
            foreach (SudokuCell cell in cells)
            {
                if (!string.Equals(cell.Value.ToString(), cell.Text))
                {
                    wrongCells.Add(cell);
                }
            }
            if (wrongCells.Any())
            {
                foreach (SudokuCell cell in wrongCells)
                {
                    cell.BackColor = Color.Red;
                    MessageBox.Show("Wrong inputs");
                }
            }
            else
            {
                MessageBox.Show("You wins");
            }*/
            bool youWin = true;
            
            foreach (SudokuCell cell in cells)
            {
                int value = int.Parse(cell.Text);
                if (!isValidNumber(value, cell.X, cell.Y))
                {
                    youWin = false;
                    MessageBox.Show("You lost!");
                }

            }
            if (youWin)
            {
                MessageBox.Show("You win!");
            }
            
        }

        private void btnClear_Click(object sender, EventArgs e)
        {
            Clear();
        }

        private void Clear()
        {
            foreach (SudokuCell cell in cells)
            {
                if (cell.IsLocked == false)
                {
                    cell.Clear();
                }
            }
        }
        /*private void removeUnlockedNumbers()
        {
            foreach (SudokuCell cell in cells)
            {
                if (!cell.IsLocked)
                {
                    cell.Text = String.Empty;
                    cell.Value = 0;
                }
            }
        }*/

        private void Solve()
        {

        }

        private void btnSolve_Click(object sender, EventArgs e)
        {
            Clear();
            findValueForNextCell(0, -1);
            showAllNumbers();
        }
    }
}
/*public void generateNumbers()
        {
            foreach (SudokuCell cell in cells)
            {
                List<int> availableNums = Enumerable.Range(1, 9).ToList();
                while (availableNums.Count > 0)
                {
                    int randomNum = rand.Next(0, availableNums.Count);
                    if (!isValidRow(cell, randomNum))
                    {
                        continue;

                    }
                    else
                    {
                        setValue(cell, randomNum);
                        availableNums.Remove(randomNum);
                    }
                }
            }



        }*/
/*public bool isValidCol(int x, int y, int value)
{
  for (int i = 0; i < 9; i++)
  {
      if (i != y && cells[x, i].Value == value)
      {
          return false;
      }
  }
  return true;
  }
public bool isValidRow(int x, int y, int value)
{
  for (int i = 0; i < 9; i++)
  {
      if (i != x && cells[i, y].Value == value)
      {
          return false;
      }
  }
  return true;
}
public bool isValidBlock(int x, int y, int value)
{
  List<SudokuCell> blockList = generateBlockList((x / 3) * 3, (y / 3) * 3);
  foreach (SudokuCell cell in blockList)
  {
      if (cell != cells[x, y] && cell.Value == value)
      {
          return false;
      }
  }

  return true;
}*/
/*public void checkNumbers(BoolDelegate isValidSection) 
      {
          BoolDelegate bd = new BoolDelegate(isValidSection);
          foreach (SudokuCell cell in cells)
          {
              int lastValue = cell.Value;
              List<int> availableNums = Enumerable.Range(1, 9).ToList();
              while (availableNums.Count > 0)
              {
                  int randomNum = rand.Next(0, availableNums.Count);
                  if (!isValidSection(cell.X, cell.Y, randomNum))
                  {
                      continue;

                  }
                  else
                  {
                      setValue(cell, randomNum);
                      availableNums.Remove(randomNum);
                  }
              }
          }


       }*/
//public delegate bool BoolDelegate(int x, int y, int value);
