import 'package:flutter/material.dart';
import 'package:tic_tac_game/game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:MediaQuery.of(context).orientation==Orientation.portrait?Column(
          children: [
            ...firstBlock(),
            _expanded(context),
            ...lastBlock(),
            const SizedBox(height:20,),
          ],
        ):Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  ...firstBlock(),
                  ...lastBlock(),
                ],
              ),
            ),
            _expanded(context),
          ],
        ),
      ),
    );
  }
  List firstBlock(){
    return[
      SwitchListTile.adaptive(
          title: const Text(
            'Turn On/off Two Player',
            style: TextStyle(color: Colors.white, fontSize: 28),
            textAlign: TextAlign.center,
          ),
          value: isSwitched,
          onChanged: (bool newValue) {
            setState(() {
              isSwitched = newValue;
            });
          }),
      Text(
        'It\'s $activePlayer turn'.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 52),
        textAlign: TextAlign.center,
      ),
    ];

  }

 List lastBlock(){
    return[
      Text(
        result,
        style: const TextStyle(color: Colors.white, fontSize: 42),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerX = [];
            Player.playerO = [];
            activePlayer = 'X';
            gameOver = false;
            turn = 0;
            result = '';
          });
        },
        icon: const Icon(Icons.replay),
        label: const Text(
          'Repeat The Game',
          style: TextStyle(color: Colors.white, fontSize: 24),
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all(Theme
                .of(context)
                .splashColor)),
      ),
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                crossAxisCount: 3,
                children: List.generate(
                    9,
                        (index) =>
                        InkWell(
                          onTap: gameOver ? null : () => _onTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme
                                  .of(context)
                                  .splashColor,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: Center(
                              child: Text(
                                Player.playerX.contains(index)
                                    ? 'X'
                                    : Player.playerO.contains(index)
                                    ? 'O'
                                    : '',
                                style: TextStyle(
                                    color: Player.playerX.contains(index)
                                        ? Colors.amber
                                        : Colors.red,
                                    fontSize: 52),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        )),
   ));
  }

  _onTap(int index) async {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
    }
    if(!isSwitched && !gameOver&&turn!=9){
      await game.autoPlay(activePlayer);
      updateState();
    }

  }

  void updateState() {
    return setState(() {
      activePlayer = (activePlayer == 'X') ? 'O' : 'X';
      turn++;
      String winnerPlayer=game.checkWinner();
      if(winnerPlayer!=''){
        gameOver=true;
        result='$winnerPlayer is the winner';
      }
      else if(!gameOver&&turn==9){
        result='It\'s Draw!';
      }
    });
  }
}
