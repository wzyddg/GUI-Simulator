import gab.opencv.*;
import processing.video.*;
import java.awt.*;


Integer folderNameIndex=0;
Capture video;
OpenCV opencv;

Integer cursorX = 0;
  Integer cursorY = 0;
  Integer pcursorX = 0;
  Integer pcursorY = 0;
  Rectangle[] hands;
  PImage hand;
  PImage folderPic;
  PImage folderSelectedPic;
  Integer handSize = 32;
  ArrayList<Folder> folders;
  Integer folderWidth = 100;
  Integer folderHeight = 80;
  Folder selected;
  Character pPress = 'a';
  Integer deviationX=0;
  Integer deviationY=0;

public class Folder {
  
  String name;
  
  public Folder() {
    // TODO Auto-generated constructor stub
    folderNameIndex++;
    name = "folder_" + folderNameIndex ; 
    
  }
  
  public Folder(Folder folder) {
    name = "Copy of " + folder.name ;
  }

}

  void setup() {
    size(1440, 480);
    video = new Capture(this, 640, 480);
    opencv = new OpenCV(this, 640, 480);
    opencv.loadCascade("aGest.xml");
    hand = loadImage("Hand.png");
    folderPic = loadImage("Folder.png");
    folderSelectedPic = loadImage("FolderSelected.png");
    video.start();
    folders = new ArrayList<Folder>();
    
    for (int i = 0; i < 4; i++) {
      Folder folder = new Folder();
      folders.add(folder);
    }
  }

  void draw() {
    background(0xBBBBBB);
    opencv.loadImage(video);
    image(video, 0, 0);
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    hands = opencv.detect();
    for (int i = 0; i < hands.length; i++) {
      rect(hands[i].x, hands[i].y, hands[i].width, hands[i].height);
    }
    getCursorXY();
    // all above is getting the cursor
    // draw folders first , than cursor

    // now get selected
    if (!keyPressed) {
      if (pPress != 'm'&&pPress != 'M') {
        for (Folder folder : folders) {
          int index = folders.indexOf(folder);
          if (cursorY / folderHeight * 8 + (cursorX - 640)
              / folderWidth == index) {
            selected = folder;
            break;
          }
          selected = null;
        }
      } else if(selected!=null){
        int[] nums = {
            (cursorX - 640) / folderWidth + cursorY / folderHeight
                * 8, folders.size(),
            (cursorX - 640) / folderWidth + folders.size() / 8 * 8 };
        folders.add(min(nums), selected);
        // move over , set selected one back to the arrraylist
      }
      pPress = 'a';
    }
    // got selected

    // now draw
    int row = 0;
    int column = 0;
    fill(0);
    for (Folder folder : folders) {
      if (folder != null) {
        image((folder == selected ? folderSelectedPic : folderPic), 640
            + column * folderWidth, row * folderHeight,
            folderWidth, folderHeight);
        text(folder.name, 640 + column * folderWidth+5, row
            * folderHeight + 72);
      }

      column++;
      row += column / 8;
      column = column % 8;
    }

    if (keyPressed) {
      if (key == 'C' || key == 'c') {
        if (pPress != 'c' && folders.size() < 48)
          if (selected != null
              && !hasFolderNamed("Copy of " + selected.name)) {
            folders.add(new Folder(selected));
            pPress = 'c';
          }
      } else if (key == 'M' || key == 'm') {
        if (pPress != 'm') {
          int index = folders.indexOf(selected);
          deviationX = cursorX - 640 - index % 8 * folderWidth;
          deviationY = cursorY - index / 8 * folderHeight;
          folders.remove(selected);
        }
        if (selected != null) {
          image(folderSelectedPic, cursorX - deviationX, cursorY
              - deviationY, folderWidth, folderHeight);
          text(selected.name, cursorX - deviationX+5, cursorY
              - deviationY + 72);
        }
        pPress = 'm';
      } else if (key == 'N' || key == 'n') {
        if (pPress != 'n' && folders.size() < 48) {
          folders.add(new Folder());
          pPress = 'n';
        }
      } else if (key == 'D' || key == 'd') {
        if (pPress != 'd' && selected != null) {
          folders.remove(selected);
        }
        pPress = 'd';
      }
    }

    image(hand, cursorX - handSize / 2, cursorY - handSize / 2, handSize,
        handSize);
  }

  void captureEvent(Capture c) {
    c.read();
  }

  void getCursorXY() {
//     cursorX = mouseX;
//     cursorY = mouseY;
//    
    if (hands.length == 0)
      return;

    if(cursorX==0&&cursorY==0){
      Rectangle target=hands[0];
      for(Rectangle hand : hands){
        if (hand.width>target.width&&hand.height>target.height) {
          target=hand;
        }
      }
      cursorX=cursorXTrans(target.x);
      cursorY=target.y;
    }else {
      Rectangle target= bestMatch();
      if (target==null) {
        return;
      }
      pcursorX = cursorX;
      pcursorY = cursorY;
      cursorX = cursorXTrans(target.x);
      cursorY = cursorYTrans(target.y);
    }
        
  }

  Boolean hasFolderNamed(String name) {
    for (Folder folder : folders) {
      if (folder.name.equals(name))
        return true;
    }
    return false;
  }
  
  Integer cursorYTrans(Integer y){
    return y*3/2;
  }
  
  Integer cursorYReverseTrans(Integer Y){
    return Y*2/3;
  }
  
  Integer cursorXTrans(Integer x){
    return 1440-x*5/3;
  }
  
  Integer cursorXReverseTrans(Integer X){
    return (1440-X)*3/5;
  }
  
  Rectangle bestMatch(){
    Rectangle target=null;
    ArrayList<Rectangle> firstStep = new ArrayList<Rectangle>();
    for(Rectangle hand1 : hands){
      if( Math.pow(hand1.x-cursorXReverseTrans(cursorX), 2) + Math.pow(hand1.y-cursorYReverseTrans(cursorY), 2)<=1750)
        firstStep.add(hand1);
    }
    if (firstStep.size()==0)
      return target;
    target = firstStep.get(0);
    for(Rectangle hand2 : firstStep){
      if(Math.pow(hand2.x-cursorXReverseTrans(cursorX), 2) + Math.pow(hand2.y-cursorYReverseTrans(cursorY), 2)<Math.pow(target.x-cursorXReverseTrans(cursorX), 2) + Math.pow(target.y-cursorYReverseTrans(cursorY), 2)){
        target = hand2;
      }
    }
    return target;
  }
