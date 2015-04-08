class RadialMenu {

  int holder;

  float x, y;
  float offsetX, offsetY;
  float innerRadius;
  float outerRadius;
  float radius;
  float bubbleColorInt;
  String rightName;

  boolean hasSpring;

  boolean destroying;

  float flagSize;

  int numSegments;

  int[] selected;

  boolean answerIsChosen;

  int currentQuestionNumber;

  int rectWidth;

  //highlighting effect before being destroyed
  boolean highlighting;

  boolean help;

  boolean deleteRequested;

  boolean dragging;

  // Constructor
  RadialMenu(float x, float y) {
    this.x = x;
    this.y = y;
    bubbleColorInt = random(1, 360);

    //this.radius = getRadius();
    this.innerRadius = menuSize/4;
    this.outerRadius = menuSize;

    radius = (innerRadius + outerRadius) / 2 + 20;

    destroying = false;

    flagSize = 400;

    holder = 999;

    selected = new int[questions.size()];//999 if unanswered
    for (int i = 0; i < questions.size(); i++) {
      selected[i] = 999;
    }

    answerIsChosen = false;

    currentQuestionNumber = 0;

    rectWidth = width/200;

    highlighting = false;
    help = false;
    deleteRequested = false;
    dragging = false;
  }

  void destroy() {
    destroying = true;
  }

  void moveByTouch(float touchX, float touchY) {
    float oldX = x;
    float oldY = y;
    x = touchX-offsetX;
    y = touchY-offsetY;

    //WALL COLLISION DETECTION1
    //        if ((x + radius > width)) {//RIGHT
    //            x = width - radius;
    //        }
    //        else if ((x - radius < 0)) {//LEFT
    //            x = 0 + radius;
    //        }
    //        
    //        if (y + radius + BOUNDRY_SIZE > height) {//BOTTOM
    //            y = height - radius - BOUNDRY_SIZE;
    //        }
    //        else if (y - 1.5*radius - BOUNDRY_SIZE < 0) {//TOP
    //            y = 1.5*radius + BOUNDRY_SIZE;
    //        }
    //        
    //        //SUBMISSION BOTTOM COLLISION PREVENTION
    //        if ((y + radius + BOUNDRY_SIZE > height*13/16) && (currentQuestionNumber != questions.size() - 1)) {
    //            y = height*13/16 - radius - BOUNDRY_SIZE;
    //        }
    //        //HIGHLIGHT MENU ON ENTERING SUBMISSION BOX
    //        if(y + radius > height*13/16 && (currentQuestionNumber == questions.size() - 1))  highlighting = true;
    //        else  highlighting = false;


    //RADIAL MENU COLLISION DETECTION 1
    RadialMenu bub;
    for (int i = 0; i < menus.size(); i++) {
      if (menus.get(i) == this)  continue;
      bub = menus.get(i);
      float distanceX = bub.x - x;
      float distanceY = bub.y - y;
      float theta = atan2(distanceY, distanceX);
      float distance = sqrt(distanceX*distanceX + distanceY*distanceY);
      float moveBack = 2*radius + 30 - distance;
      if (distance <= 2*radius + 30) {  //accounting for help text
        //MENUS ARE TOUCHING
        y = y - moveBack*sin(theta);
        x = x - moveBack*cos(theta);
      }
    }

    //WALL COLLISION DETECTION2
    //ACCOUNTS FOR PUSH BACK FROM PASSED RADIAL MENU CHECK 
    if ((x + radius +15 > width)) {//RIGHT
      x = width - (radius + 15);
    }
    else if ((x - (radius + 15)< 0)) {//LEFT
      x = 0 + radius + 15;
    }

    if (y + radius +15 + BOUNDRY_SIZE > height) {//BOTTOM
      y = height - (radius + 15) - BOUNDRY_SIZE;
    }
    else if (y - (radius + 15)- BOUNDRY_SIZE < 0) {//TOP
      y = radius + 15 + BOUNDRY_SIZE;
    }
    //SUBMISSION BOTTOM COLLISION PREVENTION
    if ((y + radius + 15 + BOUNDRY_SIZE > height*13/16) && (currentQuestionNumber != questions.size() - 1)) {
      y = height*13/16 - (radius + 15) - BOUNDRY_SIZE;
    }
    //HIGHLIGHT MENU ON ENTERING SUBMISSION BOX
    if (y + radius > height*13/16 && (currentQuestionNumber == questions.size() - 1))  highlighting = true;
    else  highlighting = false;

    //RADIAL MENU COLLISION DETECTION 2
    for (int i = 0; i < menus.size(); i++) {
      if (menus.get(i) == this)  continue;
      bub = menus.get(i);
      float distanceX = bub.x - x;
      float distanceY = bub.y - y;
      //float theta = atan2(distanceY, distanceX);
      float distance = sqrt(distanceX*distanceX + distanceY*distanceY);
      //float moveBack = 2*radius + 30 - distance;
      if (distance < 2*radius + 30) { //accounting for help text
        //MENUS ARE TOUCHING
        y = oldY;
        x = oldX;
      }
    }
  }

  // This function calculates radius size
  float getRadius() {
    return menuSize;
  }

  void display() {
    pushMatrix(); println(++matrixcount);
    matrices++;
    pushStyle();
    Question q = questions.get(currentQuestionNumber);
    numSegments = q.numAnswers;
    
    translate(x, y);

    //SEGMENTS FOR THE ANSWER BUTTONS ON UPPER HALF OF MENU
    pushStyle();
    displayAnswerButtonsInverted(q);
    popStyle();

    //SEGMENTS FOR THE CLOSE AND HELP BUTTONS AT LOWER HALF OF MENU
    displayMenuToolsInverted();
    
    //ADDED FOR THE ARROW BUTTONS
    displayArrowButtonsInverted();

    if (!help && !deleteRequested) {
           
    if(currentQuestionNumber == questions.size()-1){
      displaySubmissionArrow();
    }
      
    // Draw QR code if currentQuestionNumber is second to
    // last question
    if(currentQuestionNumber == questions.size()-2){
      selected[currentQuestionNumber] = 0; // Select "answer choice" for the user
      image(qrCode, -rectWidth * 3/2, rectWidth * 2/3, 3 * rectWidth, 3 * rectWidth); 
    }

      //PRINT QUESTION STRAIGHT - TOP
      //              pushStyle();
      //              textFont(monoSpacedPlain128Font);
      //              textAlign(CENTER);
      //              textSize(width/200);
      //              
      //              fill(#FFFF00);
      //              text(q.question, -outerRadius, -outerRadius + 30, 2*outerRadius, 3*(textAscent() + textDescent()));
      //              popStyle();

      //PRINT QUESTION STRAIGHT - MIDDLE
      //              pushStyle();
      //              textFont(monoSpacedPlain128Font);
      //              textAlign(CENTER);
      //              rectMode(CENTER);
      //              textSize(width/230);
      //              
      //              fill(#FFFF00);
      //              text(q.question, 0, textAscent() + textDescent(), 2*outerRadius, 3*(textAscent() + textDescent()));
      //              popStyle();


      //PRINT QUESTION CURVED
      //              textFont(monoSpacedPlain17Font);
      //              textSize(width/230);
      //              printCurved(q.question, outerRadius - width/128, 3*PI/2 - textWidth(q.question)*0.5/(outerRadius - width/128), #FFFF00, false);

      //PRINT QUESTION CENTERED
      printQuestionCentered(q);
    }

    //Print progress line
    pushStyle();
    textFont(monoSpacedPlain17Font);
    textAlign(CENTER);
    textSize(width/300);


    fill(#FFFF00);        
    // Print which question out of the total number of questions the user is on
    if (currentQuestionNumber + 1 <= questions.size() - 2 && !help && !deleteRequested) {
      text("" + (currentQuestionNumber + 1) + "/" + (questions.size()-2), 0, innerRadius);
    }
    popStyle();
    
    if(deleteRequested){
        confirmDelete(); 
    }

    if (help) {
      displayHelpInverted();
    }


    //        // Draw Menu Debuging Circles
    //        stroke(255,0,0);
    //        strokeCap(SQUARE);
    //        strokeWeight(1);
    //        ellipse(0,0, outerRadius, outerRadius);
    //        ellipse(0,0, innerRadius, innerRadius);


    popStyle();
    popMatrix(); println(--matrixcount);
  }

  void printCurved(String word, float radius, float startingPoint, color fontColor, boolean upsideDown) {
    fill(255, 0, 0);
    //textSize(width/300);

    //DRAW ANSWER TEXT
    float arclength = 0;

    //int textSize = 17; //to account for size change when drawing answer text
    for (int j = 0; j < word.length(); j++) {
      // Instead of a constant width, we check the width of each character.
      char currentChar = word.charAt(j);
      float w = textWidth(currentChar);
      if (upsideDown)  w = -w;
      float r = radius;

      // Each box is centered so we move half the width
      arclength += w/2;
      // Angle in radians is the arclength divided by the radius
      // Starting on the left side of the circle by adding PI
      float theta = startingPoint + arclength / r;

      pushStyle();
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      translate(r*cos(theta), r*sin(theta));
      if (upsideDown)  rotate(theta-PI/2); // rotation is offset by 90 degrees
      else            rotate(theta+PI/2);
      fill(fontColor);
      text(currentChar, 0, 0);
      //popMatrix(); println(--matrixcount);
      // Move halfway again
      if (upsideDown)  rotate(-theta+PI/2); // rotation is offset by 90 degrees
      else            rotate(-theta-PI/2);
      
      translate(-r*cos(theta), -r*sin(theta));
      arclength += w/2;
      popStyle();
    }
  }

  void submit() {
    //save to csv
    String words = new String();
    for (int i = 0; i < questions.size() - 1; i++) {
      words = words + questions.get(i).answers[selected[i]] + ",";
    }

    //Gets month-day-year-hour-minute of submission
    String timestamp;
    timestamp = nf(month(), 2) + "-" + nf(day(), 2) + "-" + year() +  " "  + nf(hour(), 2) + ":" + nf(minute(), 2);
    println(timestamp);
    words = words + timestamp;
    appendTextToFile("answers.csv", words);
    //answers.add(words);
    menus.remove(this);
    surveysSubmitted++;
  }
  
  void confirmDelete(){
      pushStyle();
      textFont(monoSpacedPlain17Font);
      textAlign(CENTER);
      stroke(#9B0000, 100);
      strokeWeight(1);
      fill(255, 150);
      ellipse(0, 0, radius*13/16, radius*13/16);
      fill(#9B0000);
      
      text("Are", 0, -15);      
      text("you sure you want to", 0, 0);      
      text("delete your survey", 0, 15);
      text("without saving?", 0, 30);
      
      int rectWidth = width/200;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      //translate(0, -2*rectWidth);
      triangle(-rectWidth, -2*rectWidth, 0, -rectWidth-2*rectWidth, rectWidth, -2*rectWidth);
      //popMatrix(); println(--matrixcount);
      
      textFont(sansSerifBold100);
      textSize(70);
      
      float r = radius - width/130;
      float theta;
      
      //No segment
      noFill();
//      if (highlighting) stroke(#FF3636);
//      else stroke(#FF3636, 100);
      strokeCap(SQUARE);
      strokeWeight(width/43.2);
      arc(0, 0, outerRadius, outerRadius, PI + PI/3 + PI/180, PI + PI/2 - PI/180);
      theta = PI + 5*PI/12;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      //translate(r*cos(theta), r*sin(theta));
      //rotate(theta-PI/2); // rotation is offset by 90 degrees
      fill(0);
      text("Y", r*cos(theta), 30+r*sin(theta));
      //popMatrix(); println(--matrixcount);
  
      //Yes segment
      noFill();
//      if () stroke(#0052FF);
//      else stroke(#0052FF, 100);
      strokeCap(SQUARE);
      strokeWeight(width/43.2);
      arc(0, 0, outerRadius, outerRadius, PI + PI/2 + PI/180, PI + 2*PI/3 - PI/180);
      theta = PI + 7*PI/12;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      //translate(r*cos(theta), r*sin(theta));
      fill(0);
      text("N", r*cos(theta), 30+r*sin(theta));
      //popMatrix(); println(--matrixcount);
      
      popStyle();
  }

  // Checks if touchs is inside transparent inner circle     
  boolean innerContains(float x, float y) {
    boolean inside = false;
    if (sqrt((x-this.x)*(x-this.x) + (y-this.y)*(y-this.y)) <= this.innerRadius + width/288) {
      inside = true;
    }
    return inside;
  }

  // Checks if touch is inside one of the menu segments
  boolean outerContains(float x, float y) {
    boolean inside = false;
    if ((sqrt((x-this.x)*(x-this.x) + (y-this.y)*(y-this.y)) <= this.radius)
      && (sqrt((x-this.x)*(x-this.x) + (y-this.y)*(y-this.y)) >= this.innerRadius)) {
      inside = true;
      answerIsChosen = true;
    }
    return inside;
  }

  boolean backArrowContains(float touchX, float touchY) {
    if (currentQuestionNumber == 0) {
      return false;
    }

    boolean inside = false;
    //pushMatrix(); println(++matrixcount);
    //matrices++;

    //translate(x, y);

    float angle = atan2(touchY-y, touchX-x);
    if (angle < 0)  angle += 2*PI;

    if (angle < 4*PI/3 - PI/180 && angle > PI + PI/180) {
      inside = true;
    } 

    //popMatrix(); println(--matrixcount);
    return inside;
  }

  boolean nextArrowContains(float touchX, float touchY) {
    if (selected[currentQuestionNumber] == 999 || currentQuestionNumber == questions.size()) {
      return false;
    }

    boolean inside = false;
    //pushMatrix(); println(++matrixcount);
    //matrices++;
    //translate(x, y);

    float angle = atan2(touchY-y, touchX-x);
    if (angle < 0)  angle += 2*PI;

    if (angle < 2*PI - PI/180 && angle > 5*PI/3 + PI/180) {
      inside = true;
    } 

    //popMatrix(); println(--matrixcount);
    return inside;
  }

  boolean deleteButtonContains(float touchX, float touchY) {
    boolean inside = false;
        //pushMatrix(); println(++matrixcount);
        //matrices++;
    
        //translate(x, y);
    
        float angle = atan2(touchY-y, touchX-x);
        if (angle < 0)  angle += 2*PI;
    
        if (angle < PI + 2*PI/3 - PI/180 && angle > PI + PI/2 + PI/180) {
          inside = true;
        }
    
        //popMatrix(); println(--matrixcount); 
    return inside;
  }

  boolean helpButtonContains(float touchX, float touchY) {
    boolean inside = false;
    //pushMatrix(); println(++matrixcount);
    //matrices++;

    //translate(x, y);

    float angle = atan2(touchY-y, touchX-x);
    if (angle < 0)  angle += 2*PI;

    if (angle < PI + PI/2 - PI/180 && angle > PI + PI/3 + PI/180) {
      inside = true;
    }

    //popMatrix(); println(--matrixcount);  
    return inside;
  }

  //Checks if touch could produce menu inside sumbission box
  boolean subBoxContains(float touchX, float touchY) {
    return touchY >= (height*13/16 - radius);
  }

  void changeSelectedSegment(float touchX, float touchY) {
    //pushMatrix(); println(++matrixcount);
    //matrices++;

    //translate(x, y);

    float angle = atan2(touchY-y, touchX-x);
    if (angle < 0)  angle += 2*PI;

    for (int i = 0; i < numSegments; i++) {
      if (angle < (i+1)*PI/numSegments - PI/180 && angle > PI/180 + i*PI/numSegments) {
        selected[currentQuestionNumber] = i;
        print(i);
      }
    }
    //popMatrix(); println(--matrixcount);
    //See which quadrant was last touched and set selected to the index of that quadrant. 0-3 clockwise from bottom right
  }  

  // Draws arrow to proceed to next question   
  void drawNextArrow(int alpha) {
    int rectWidth = width/144;
    //pushMatrix(); println(++matrixcount);
    //matrices++;
    pushStyle();
    noStroke();
    fill(255, alpha);
    //translate(radius*6/10, -radius*5/10);
    triangle(radius*6/10, -radius*5/10, radius*6/10, 2*rectWidth-radius*5/10, rectWidth+radius*6/10, rectWidth-radius*5/10);
    //triangle(0, -rectWidth, 0, rectWidth, rectWidth, 0);
    popStyle();
    //popMatrix(); println(--matrixcount);
  }

  // Draws arrow to go back to previous question
  void drawBackArrow(int alpha) {
    int rectWidth = width/144;
    //pushMatrix(); println(++matrixcount);
    //matrices++;
    pushStyle();
    noStroke();
    fill(255, alpha);
    //translate(-radius*6/10, -radius*5/10);   
    //rect(-rectWidth/2, -rectWidth/2, rectWidth, rectWidth);
    triangle(-radius*6/10,  -radius*5/10, -radius*6/10, 2*rectWidth -radius*5/10, -rectWidth-radius*6/10, rectWidth -radius*5/10);
    popStyle();
    //popMatrix(); println(--matrixcount);
  }
  
  void displaySubmissionArrow() {
      int rectWidth = width/200;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      pushStyle();
      //translate(0, 2*rectWidth);
      fill(#FFFF00);
      noStroke();
      triangle(-rectWidth, 2*rectWidth, 0, 3*rectWidth, rectWidth, 2*rectWidth);
      popStyle();
      //popMatrix(); println(--matrixcount);  
//      print("HI THERE!\n"); 
//      noLoop();
  }

  void displayAnswerButtonsInverted(Question q) {
    textFont(monoSpacedPlain17Font);
    for (int i = 0; i < numSegments; i++) {

      if (highlighting) stroke(255);
      else if (i == selected[currentQuestionNumber] && currentQuestionNumber != questions.size()-1)  stroke(255);
      else               stroke(255, 100);
      strokeCap(SQUARE);
      strokeWeight(width/43.2);
      noFill();
      arc(0, 0, outerRadius, outerRadius, 0 + PI/180 + i*PI/numSegments, 0 + (i+1)*PI/numSegments - PI/180);

      if (textWidth(q.answers[i]) < PI*innerRadius/numSegments) {
        // For every box
        printCurved(q.answers[i], radius - width/100, 0 + (2*i + 1)*PI/(2*numSegments) + textWidth(q.answers[i])*0.55/(radius - width/100), #000000, true);
      }
      else {
        String[] lines = split(q.answers[i], ' ');
        for (int j = 0; j < lines.length; j++) {
          printCurved(lines[j], radius - width/80 + j*width/250, 0 + (2*i + 1)*PI/(2*numSegments) + textWidth(lines[j])*0.55/(radius - width/100), #000000, true);
        }
      }
    } 
  }
  
  void displayMenuToolsInverted() {
    textFont(sansSerifBold100);
    textSize(70);
    float r = radius - width/130;
    float theta;
    
    if(!deleteRequested){
      
      //delete button segment
      noFill();
      if (highlighting) stroke(#FF3636);
      else stroke(#FF3636, 100);
      strokeCap(SQUARE);
      strokeWeight(width/43.2);
  
      arc(0, 0, outerRadius, outerRadius, PI + PI/2 + PI/180, PI + 2*PI/3 - PI/180);
  
      theta = PI + 7*PI/12;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      pushStyle();
      //translate(r*cos(theta), r*sin(theta));
      //rotate(theta-PI/2); // rotation is offset by 90 degrees
      fill(0);
      text("X", r*cos(theta)-20, r*sin(theta)+30);
      popStyle();
      //popMatrix(); println(--matrixcount);
  
      //help button segment
      noFill();
      if (highlighting) stroke(#0052FF);
      else stroke(#0052FF, 100);
      strokeCap(SQUARE);
      strokeWeight(width/43.2);
  
      arc(0, 0, outerRadius, outerRadius, PI + PI/3 + PI/180, PI + PI/2 - PI/180);
  
      theta = PI + 5*PI/12;
      //pushMatrix(); println(++matrixcount);
      //matrices++;
      pushStyle();
      //translate(r*cos(theta), r*sin(theta));
      fill(0);
      text("?", r*cos(theta)-20, r*sin(theta)+30);
      popStyle();
      //popMatrix(); println(--matrixcount);
    } 
  }
  
  void displayArrowButtonsInverted() {
    noFill();
    if (highlighting) stroke(255);
    else stroke(255, 50);
    strokeCap(SQUARE);
    strokeWeight(width/43.2);

    arc(0, 0, outerRadius, outerRadius, PI + 0 + PI/180, PI + PI/3 - PI/180);

    noFill();
    if (highlighting) stroke(255);
    else stroke(255, 50);
    strokeCap(SQUARE);
    strokeWeight(width/43.2);

    arc(0, 0, outerRadius, outerRadius, PI + 2*PI/3 + PI/180, PI + PI - PI/180);
    
    // With if statement, draws back and next arrows if outerContains returns true
    if (currentQuestionNumber != 0) {
      drawBackArrow(255);
    }
    else {
      drawBackArrow(50);
    }
    if (selected[currentQuestionNumber] != 999 && currentQuestionNumber != questions.size() - 1) {
      drawNextArrow(255);
    }
    else {
      drawNextArrow(50);
    }
  }  
  
  void printQuestionCentered(Question q) {
      pushStyle();
      textFont(monoSpacedPlain17Font);
      textAlign(CENTER);
      rectMode(CENTER);
      textSize(width/300);

      fill(#FFFF00);
      text(q.question, 0, 10, 2*innerRadius, 3.1*(textAscent() + textDescent())*ceil(textWidth(q.question)/(innerRadius*4)));
      popStyle();
  }  
  
  void displayHelpInverted() {
      pushStyle();
      textFont(monoSpacedPlain17Font);
      textAlign(CENTER);

      String printText;

      stroke(#0052FF, 100);
      strokeWeight(1);

      fill(255, 150);
      ellipse(0, 0, radius*13/16, radius*13/16);
      fill(#0222D1);
      text("HOLD HERE TO DRAG", 0, 0);
      //text(""+frameRate, 0, 0);

      printText = "SELECT ONE OF THE FOLLOWING ANSWER CHOICES";
      printCurved( printText, 
      radius + 15, 
      PI/2 + textWidth(printText)*0.48/(radius), 
      #0222D1, 
      true);

      //          fill(255, 50);
      //          rect(radius*3/4, radius*3/4, 400, 100, 50);
      //          fill(#AA1111);
      //          text("Tap this arrow to go to next question", radius*3/4, radius*3/4 + 50, 400, 100);
      printText = "NEXT QUESTION";
      printCurved( printText, 
      radius + 5, 
      11*PI/6 - textWidth(printText)*0.5/(radius), 
      #0222D1, 
      false);

      //          fill(255, 50);
      //          rect(-radius*3/4 - 400, radius*3/4, 400, 100, 50);
      //          fill(#AA1111);
      //          text("Tap this arrow to go to previous question", -radius*3/4 - 400, radius*3/4 + 50, 400, 100);
      printText = "PREVIOUS QUESTION";
      printCurved( printText, 
      radius + 5, 
      7*PI/6 - textWidth(printText)*0.5/(radius), 
      #0222D1, 
      false);

      printText = "CLOSE";
      printCurved( printText, 
      radius + 5, 
      PI + 7*PI/12 - textWidth(printText)*0.5/(radius), 
      #0222D1, 
      false);

      printText = "TOGGLE HELP";
      printCurved( printText, 
      radius + 5, 
      PI + 5*PI/12 - textWidth(printText)*0.5/(radius), 
      #0222D1, 
      false); 
      popStyle(); 
  }
}
