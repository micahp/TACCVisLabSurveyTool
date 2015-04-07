import TUIO.*;
import java.util.Iterator;

public class TuioHandler implements TuioListener {
  protected PApplet p;
  protected int maxCursors;
  protected TuioClient tuioClient;
  protected ArrayList<TuioCursor> touchObjects = new ArrayList<TuioCursor>();

  public TuioHandler(PApplet p, int maxCursors) {
    this(p, maxCursors, null);
  }

  public TuioHandler(PApplet p, int maxCursors, TuioClient tuioClient) {
    this.p = p;
    this.maxCursors = maxCursors;

    // Create or set tuioClient
    if (tuioClient == null) {
      this.tuioClient = new TuioClient();
      this.tuioClient.connect();
    } 
    else {
      this.tuioClient = tuioClient;
    }
    // Add this as listener
    this.tuioClient.addTuioListener(this);

    // To disconnect tuioClient after applet stops
    //p.registerDispose(this);
  }

  // called when user presses "Escape" or
  // clicks "X" on sketch window
  public void dispose() {
    //    String[] list = new String[answers.size()];
    //    list = answers.toArray(list);
    //    saveStrings("data/answers.csv", list);
    println("Diconnecting TUIO Client");
    tuioClient.disconnect();
  }

  public synchronized void addTuioCursor(TuioCursor tcur) {
    //make sure new touch isn't too close to others
    float newTouchX = tcur.getScreenX(p.width);
    float newTouchY = tcur.getScreenY(p.height);
    for(TuioCursor touch : touchObjects){
      float touchX = touch.getScreenX(p.width);
      float touchY = touch.getScreenY(p.height);
      if(sqrt(((newTouchX - touchX)*(newTouchX - touchX)) + ((newTouchY - touchY)*(newTouchY - touchY))) <= menuSize)
          return;
    }
    if(MENUSINVERTED) {
    if (touchObjects.size() < maxCursors) {
      touchObjects.add(tcur);
      float touchX = tcur.getScreenX(p.width);
      float touchY = tcur.getScreenY(p.height);
      int id = tcur.getCursorID();

      RadialMenu bub;
      boolean flag = false;
      if(subBoxContains(touchX, touchY))
        flag = true;
      for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if (bub.innerContains(touchX, touchY) && !(bub.hasSpring)) {
          bub.help = false;
          bub.deleteRequested = false;
          bub.hasSpring = true;
          bub.holder = id;
          bub.offsetX = touchX - bub.x;
          bub.offsetY = touchY - bub.y;
          flag = true;
        }
        else if (bub.outerContains(touchX, touchY)) {
          boolean helpFlag = false;
          boolean deleteFlag = false;
          bub.changeSelectedSegment2(touchX, touchY);
          if (bub.deleteButtonContains2(touchX, touchY) && !bub.deleteRequested) { 
            bub.deleteRequested = true;
            deleteFlag = true;
          }else if(bub.deleteButtonContains2(touchX, touchY) && bub.deleteRequested) {
            bub.deleteRequested = false; 
          }
          
          if (bub.helpButtonContains2(touchX, touchY) && !bub.deleteRequested) { 
            bub.help = bub.help ? false : true;
            helpFlag = true;
          }else if (bub.helpButtonContains2(touchX, touchY) && bub.deleteRequested) {
            menus.remove(bub); 
          }

          //Moved here because the arrows are now 'buttons' on the circle
          if (bub.backArrowContains2(touchX, touchY)) {
            if (bub.currentQuestionNumber > 0) {
              bub.currentQuestionNumber--;
              //                    bub.selected = 999;
            }
          }

          if (bub.nextArrowContains2(touchX, touchY)) {
            if (bub.currentQuestionNumber < questions.size() - 1) {
              bub.currentQuestionNumber++;
              //                    bub.selected = 999;
            }
          }
          flag = true;
          if (!helpFlag)  bub.help = false; //whenever anywhere else is clicked help is turned off
          if(!deleteFlag) bub.deleteRequested = false; //whenever anywhere else is clicked delete is turned off
        }
        if (sqrt((bub.x-touchX)*(bub.x-touchX) + (bub.y-touchY)*(bub.y-touchY)) <= 2*bub.radius + 30) {
          flag = true;
          //Stops user from creating menu that touches submission box
        }
        else if (bub.subBoxContains(touchX, touchY)) {
          flag = true;
        }
      }
      if (!flag && menus.size() < MENUCOUNT) {
        menus.add(new RadialMenu(touchX, touchY));
        flag = false;
      }
    }
    //ELSE CONDITION FOR IF MENUS ARE NOT INVERTED
    }else{
      if (touchObjects.size() < maxCursors) {
      touchObjects.add(tcur);
      float touchX = tcur.getScreenX(p.width);
      float touchY = tcur.getScreenY(p.height);
      int id = tcur.getCursorID();

      RadialMenu bub;
      boolean flag = false;
      for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if (bub.innerContains(touchX, touchY) && !(bub.hasSpring)) {
          bub.help = false;
          bub.deleteRequested = false;
          bub.hasSpring = true;
          bub.dragging = true;
          bub.holder = id;
          bub.offsetX = touchX - bub.x;
          bub.offsetY = touchY - bub.y;
          flag = true;
        }
        else if (bub.outerContains(touchX, touchY)) {
          boolean helpFlag = false;
          boolean deleteFlag = false;
          bub.changeSelectedSegment(touchX, touchY);
          if (bub.deleteButtonContains(touchX, touchY) && !bub.deleteRequested) { 
            bub.deleteRequested = true;
            deleteFlag = true;
          }else if(bub.deleteButtonContains(touchX, touchY) && bub.deleteRequested) {
            bub.deleteRequested = false; 
          }
          
          if (bub.helpButtonContains(touchX, touchY) && !bub.deleteRequested) { 
            bub.help = bub.help ? false : true;
            helpFlag = true;
          }else if (bub.helpButtonContains(touchX, touchY) && bub.deleteRequested) {
            menus.remove(bub); 
          }

          //Moved here because the arrows are now 'buttons' on the circle
          if (bub.backArrowContains(touchX, touchY)) {
            if (bub.currentQuestionNumber > 0) {
              bub.currentQuestionNumber--;
              //                    bub.selected = 999;
            }
          }

          if (bub.nextArrowContains(touchX, touchY)) {
            if (bub.currentQuestionNumber < questions.size() - 1) {
              bub.currentQuestionNumber++;
              //                    bub.selected = 999;
            }
          }
          flag = true;
          if (!helpFlag)  bub.help = false; //whenever anywhere else is clicked help is turned off
          if(!deleteFlag) bub.deleteRequested = false; //whenever anywhere else is clicked delete is turned off
        }
        if (sqrt((bub.x-touchX)*(bub.x-touchX) + (bub.y-touchY)*(bub.y-touchY)) <= 2*bub.radius + 30) {
          flag = true;
          //Stops user from creating menu that touches submission box
        }
        else if (bub.subBoxContains(touchX, touchY)) {
          flag = true;
        }
      }
      if (!flag && menus.size() < MENUCOUNT) {
        menus.add(new RadialMenu(touchX, touchY));
        flag = false;
      }
    } 
    }
  }

  public synchronized void updateTuioCursor(TuioCursor tcur) {
    Iterator<TuioCursor> it = touchObjects.iterator();
    boolean cursorHit = false;
    int id = tcur.getCursorID();
    while (it.hasNext () && !cursorHit) {
      TuioCursor touch = it.next();
      if (touch.getCursorID() == id) {
        cursorHit = true;
      }
    }
    if (cursorHit) {
      float touchX = tcur.getScreenX(p.width);
      float touchY = tcur.getScreenY(p.height);
      RadialMenu bub;
      for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if (!(bub.hasSpring) && bub.innerContains(touchX, touchY)) {
          bub.hasSpring = true;
          bub.dragging = true;
          bub.holder = id;
          bub.offsetX = touchX - bub.x;
          bub.offsetY = touchY - bub.y;
        }
        if (bub.hasSpring && bub.holder == id) {
          bub.moveByTouch(touchX, touchY);
          break;
        }
      }
    }
  }

  public synchronized void removeTuioCursor(TuioCursor tcur) {
    for (int k = 0; k < touchObjects.size(); k++) {
      TuioCursor touch = touchObjects.get(k);
      RadialMenu bub;
      for (int i = 0; i < menus.size(); i++) {
        bub = menus.get(i);
        if (bub.hasSpring && bub.holder == tcur.getCursorID()) {
          bub.hasSpring = false;
          float touchX = tcur.getScreenX(p.width);
          float touchY = tcur.getScreenY(p.height);
          if(bub.innerContains(touchX, touchY)){
            bub.dragging = false; 
          }
          bub.holder = 999;
          if (bub.y + bub.radius > (height * 13/16) && /*bub.selected[questions.size() - 1] != 999 &&*/ bub.currentQuestionNumber == questions.size() - 1) {
            bub.submit();
          }
        }
      }
      if (tcur.getCursorID() == touch.getCursorID()) {
        touchObjects.remove(touch);
      }
    }
  }

  public synchronized void debugCursors() {
    Iterator<TuioCursor> i = touchObjects.iterator();
    while (i.hasNext ()) {
      TuioCursor touch = i.next();
      p.pushStyle();
      p.stroke(50, 100);
      p.fill(230, 150);
      p.ellipse(touch.getScreenX(p.width), touch.getScreenY(p.height), 25, 25);
      p.fill(10);
      p.textSize(12);
      if (touch.getCursorID() < 10) p.text(touch.getCursorID(), touch.getScreenX(p.width) - 3, touch.getScreenY(p.height) + 4);
      else p.text(touch.getCursorID(), touch.getScreenX(p.width) - 9, touch.getScreenY(p.height) + 4);
      p.popStyle();
    }
  }

  public synchronized ArrayList<TuioCursor> getTouchObjects() {
    return touchObjects;
  }


  public void refresh(TuioTime arg0) {
  }
  public void addTuioObject(TuioObject tobj) {
  }
  public void updateTuioObject(TuioObject tobj) {
  }  
  public void removeTuioObject(TuioObject tobj) {
  }
}
