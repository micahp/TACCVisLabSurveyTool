class Question{
  String question;
  int numAnswers;
  String[] answers;
//  String[] answersRemnants;
}

void parse(){
  String[] lines;
  
  lines = loadStrings("data/realquestions.csv");
  
  for(int i = 0; i < lines.length; i++){
      String[] currentLine = split(lines[i], ',');
      
      Question q = new Question();
      q.question = currentLine[0];
      q.numAnswers = int(currentLine[1]);
      q.answers = new String[q.numAnswers];
      for(int j = 0; j < q.numAnswers; j++){
          q.answers[j] = currentLine[j+2];
      }
      
      //PRINT ANSWER CHOICES FROM LEFT TO RIGHT
      q.answers = reverse(q.answers);
      
      questions.add(q);
      
      //ATTEMPT TO ADD EVERYTHING AFTER THE FIRST WORD OF EACH QUESTION
      //TO ITS RESPECTIVE PLACE IN REMNANTS ARRAY
//      int num = 0;
//      q.answersRemnants = new String[q.answers.length];
//      for(int k = 0; k < q.answers.length; k++){
//        println(q.answers[k]);
//      }
//      while((num < q.answers[i].length()) && q.answers[i].charAt(num) != ' ') {
//          num++; 
//      }
//      if(num < q.answers[i].length() - 1)
//          q.answersRemnants[i] = q.answers[i].substring(num);
  }
  
  // QR code question
  Question qr = new Question();
  qr.question = "SCAN QR CODE TO SUBMIT ADDITIONAL SUGGESTIONS";
  qr.numAnswers = 1;
  qr.answers = new String [1];
  qr.answers[0] = "";
  questions.add(qr);
  
  // Submission question
  Question submission = new Question();
  submission.question = "SUBMIT BY DRAGGING DOWN TO SUBMIT AREA";
  submission.numAnswers = 1;
  submission.answers = new String [1];
  submission.answers[0] = "";
  questions.add(submission);
}
