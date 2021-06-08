import 'dart:math';

int getRandomColor() {
  Random random = Random();
  int percentage = random.nextInt(100);

  if (percentage < 5) {
    return 2;
  } else if (percentage < 30) {
    return 1;
  }
  return 0;
}
