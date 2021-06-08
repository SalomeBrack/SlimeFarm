int getPrice(int colorIndex) {
  switch (colorIndex) {
    case 2:
      return 50;
    case 1:
      return 20;
    case 0:
      return 5;
    default:
      return 5;
  }
}
