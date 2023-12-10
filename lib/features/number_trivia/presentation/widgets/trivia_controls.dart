import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    super.key,
  });

  @override
  State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends State<TriviaControls> {
  String? input;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          onChanged: (value) => input = value,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => addConcrete(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: 'Input a number',
            filled: true,
            fillColor: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: addConcrete,
                child: const Text('Search'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textStyle: const TextStyle(color: Colors.white),
                ),
                onPressed: addRandom,
                child: const Text('Get random trivia'),
              ),
            ),
          ],
        )
      ],
    );
  }

  void addConcrete() {
    if (input != null && input!.isNotEmpty) {
      context.read<NumberTriviaBloc>().add(GetTriviaForConcreteNumber(input!));
      controller.clear();
    }
  }

  void addRandom() {
    context.read<NumberTriviaBloc>().add(GetTriviaForRandomNumber());
    controller.clear();
  }
}
