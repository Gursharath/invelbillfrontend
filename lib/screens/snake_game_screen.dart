import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../games/snake_game.dart';

class SnakeGameScreen extends StatelessWidget {
  const SnakeGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = SnakeGame();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("🐍 Snake Game"),
        backgroundColor: const Color.fromARGB(255, 61, 151, 137),
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: SnakeGame.gridSize * SnakeGame.cellSize,
              height: SnakeGame.gridSize * SnakeGame.cellSize,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: GameWidget(game: game),
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<int>(
              valueListenable: game.scoreNotifier,
              builder: (context, score, _) {
                return Center(
                  child: Text(
                    'Score: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      size: 40, color: Colors.white),
                  onPressed: () => game.changeDirection(Vector2(-1, 0)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_upward,
                          size: 40, color: Colors.white),
                      onPressed: () => game.changeDirection(Vector2(0, -1)),
                    ),
                    const SizedBox(height: 16),
                    IconButton(
                      icon: const Icon(Icons.arrow_downward,
                          size: 40, color: Colors.white),
                      onPressed: () => game.changeDirection(Vector2(0, 1)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward,
                      size: 40, color: Colors.white),
                  onPressed: () => game.changeDirection(Vector2(1, 0)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
