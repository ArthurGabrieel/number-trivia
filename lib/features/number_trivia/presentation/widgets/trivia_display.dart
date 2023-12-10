import 'package:flutter/material.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class TriviaDisplay extends StatelessWidget {
  const TriviaDisplay({
    super.key,
    required this.trivia,
  });

  final NumberTrivia trivia;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  trivia.number.toString(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                trivia.text,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
