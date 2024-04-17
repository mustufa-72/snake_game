import 'dart:async';
//import 'dart:js_interop';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snake_game/blank_pixel.dart';
import 'package:snake_game/food_pixel.dart';
import 'package:snake_game/snake_pixel.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  //final _nameController = TextEditingController();
 // final score = TextEditingController();

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction {UP, DOWN, LEFT, RIGHT}

class _HomePageState extends State<HomePage> {

  //grid dimensions
  int rowSize = 10;
  int totalNumberofSquares = 100;

  // snake positions
  List<int> snakePos = [0,1,2,];

  // Snake direction is initially to right
  var currentDirection = snake_Direction.RIGHT;

  // food position
  int foodPos = 55;

  // game settings
  final _nameController = TextEditingController();
  final score = TextEditingController();
  bool gamehasStarted = false;
  bool gameend = false;


  // user score
  int currentScore = 0;
  // game Over
  bool gameOver(){
    //   this game is over when the snake runs into itself
    //   this occurs when there is a duplicate position int the snake position list

    // this list is the body of the snake (no head)
    List<int> bodySnake = snakePos.sublist(0, snakePos.length-1);

    if(bodySnake.contains(snakePos.last)){
      return true;
    }
    return false;

  }

  //  start the game
  void startGame(){
    gamehasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
    setState(() {
      // keep the snake moving
      moveSnake();

    //   check if the game is over
      if(gameOver()){
        timer.cancel();

      //   display a message to the user
        showDialog(context: context,
            barrierDismissible: false,
            builder: (context){
          return AlertDialog(
            title: Text('Game Over'),
            content: Column(
              children: [
                Text('Your Score is : ' + currentScore.toString()),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(hintText: 'Enter Name'),
                  
                )
              ],
            ),
            actions: [
              MaterialButton(onPressed: (){
                CollectionReference collRef = FirebaseFirestore.instance.collection('client');
                collRef.add({
                  'name': _nameController.text,
                  'score': currentScore,
                });
                Navigator.pop(context);
                setState(() {
                  gameend= true;

                });
                submitScore();

              },
              child: Text('Submit'),
                color: Colors.pink,
              )
            ],
          );
        });
      }
    });
    });
  }

  void submitScore(){
  //   get access to the collection
    var FirebaseFirestore;
    var database = FirebaseFirestore.instance;
    database.collection('highscores').add({
      "name": _nameController.text,
      "score": currentScore,
    });
  }

  void newGame(){
    setState(() {
      snakePos = [0,1,2,];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      gamehasStarted = false;
      currentScore = 0;
      gameend=false;
    });
  }

  void eatFood(){
    currentScore++;
    while(snakePos.contains(foodPos)){
      foodPos = Random().nextInt((totalNumberofSquares));
    }
  }

  void moveSnake(){
    switch(currentDirection){
      case snake_Direction.RIGHT: {
      //   adding a head
      //   if snake is at the right wall, need to re-adjust
        if(snakePos.last % rowSize == 9){
          snakePos.add(snakePos.last + 1 - rowSize);
        } else{
          snakePos.add(snakePos.last + 1);
        }
      //   remove a tail
      //   snakePos.removeAt(0);

      }
      break;
      case snake_Direction.LEFT: {
        //   adding a head
        //   if snake is at the right wall, need to re-adjust
        if(snakePos.last % rowSize == 0){
          snakePos.add(snakePos.last - 1 + rowSize);
        } else{
          snakePos.add(snakePos.last - 1);
        }
        //   remove a tail
        // snakePos.removeAt(0);

      }
      break;
      case snake_Direction.DOWN: {
        // add a head
        if(snakePos.last + rowSize > totalNumberofSquares){
          snakePos.add(snakePos.last + rowSize - totalNumberofSquares);
        }else{
          snakePos.add(snakePos.last + rowSize);
        }
        //   remove a tail
        // snakePos.removeAt(0);
      }
      break;
      case snake_Direction.UP: {
        // add a head
        if(snakePos.last < rowSize ){
          snakePos.add(snakePos.last - rowSize + totalNumberofSquares);
        }else{
          snakePos.add(snakePos.last - rowSize);
        }
        //   remove a tail
        // snakePos.removeAt(0);
      }
      break;
      default: ;
    }

  //   snake is eating food
    if(snakePos.last == foodPos){
      eatFood();

    }else{
      snakePos.removeAt(0);
    }

  }



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //   high score
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            //   user current score
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Current Score'),
                  Text(
                      currentScore.toString(),
                    style: TextStyle(fontSize: 36),

                  ),
                ],
              ),
            //   high scores
              Text("highscores..")
            ],
            // color: Colors.blue,
          ),),


        //   game grid
        Expanded(
          flex: 3,
          child: GestureDetector(
            onVerticalDragUpdate: (details){
              if(details.delta.dy > 0 && currentDirection != snake_Direction.UP){
                currentDirection = snake_Direction.DOWN;
              }else if(details.delta.dy <0 && currentDirection != snake_Direction.DOWN){
                currentDirection = snake_Direction.UP;
              }
            },
            onHorizontalDragUpdate: (details){
              if(details.delta.dx > 0 && currentDirection != snake_Direction.LEFT){
                currentDirection = snake_Direction.RIGHT;
              }else if(details.delta.dx <0 && currentDirection != snake_Direction.RIGHT){
                currentDirection = snake_Direction.LEFT;
              }
            },
            child: GridView.builder(
                itemCount: totalNumberofSquares,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: rowSize),
                itemBuilder: (context, index){
                  if(snakePos.contains(index)){
                    return const SnakePixel();
                  }
                  else if(foodPos == index){
                    return FoodPixel();
            
                  }
                  else{
                    return BlankPixel();
                  }
                }
            ),
          )
          ,),


        //   play button
        Expanded(
          child: Container(
            child: Center(
              child: MaterialButton(
                child: gameend==true?Text("Play again"): Text('PLAY'),
                color: gamehasStarted ? Colors.grey : Colors.pink,
                onPressed:gameend==true?newGame:(gamehasStarted ? (){} : startGame),
              ),
            ),
          ),),
      ],
    );
  }
}
