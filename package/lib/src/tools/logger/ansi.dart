const String escape = '\x1B';
const String reset = '$escape[0m';

/// https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#color-codes
enum AnsiStyle { colored, bold, italic, underline, blinking, strikethrough }

enum AnsiAlignment { left, right }

enum AnsiColorType { foreground, background }

enum AnsiColor {
  black(30, 40),
  red(31, 41),
  green(32, 42),
  yellow(33, 43),
  blue(34, 44),
  magenta(35, 45),
  cyan(36, 46),
  white(37, 47),
  brightBlack(90, 100),
  brightRed(91, 101),
  brightGreen(92, 102),
  brightYellow(93, 103),
  brightBlue(94, 104),
  brightMagenta(95, 105),
  brightCyan(96, 106),
  brightWhite(97, 107);

  /// Default constructor of [AnsiColor]
  const AnsiColor(
    this.foregroundCode,
    this.backgroundCode,
  );

  final int foregroundCode;
  final int backgroundCode;

  String get foreground => foregroundCode.toAnsiColor();

  String get background => backgroundCode.toAnsiColor();
}

extension on int {
  String toAnsiColor() => '$escape[${this}m';
}

extension AnsiText on String {
  String colored(AnsiColor? color, [AnsiColorType type = AnsiColorType.foreground]) {
    if (color == null) {
      return this;
    }

    final String colorCode = type == AnsiColorType.foreground ? color.foreground : color.background;
    return '$colorCode$this$reset';
  }

  String coloredByCode(String color) => color.isEmpty ? this : '$color$this$reset';

  String bold() => '$escape[1m$this$escape[22m';

  String italic() => '$escape[3m$this$escape[23m';

  String underline() => '$escape[4m$this$escape[24m';

  String blinking() => '$escape[5m$this$escape[25m';

  String strikethrough() => '$escape[9m$this$escape[29m';

  String pad(AnsiAlignment padding, int width) =>
      padding == AnsiAlignment.left ? padRight(width) : padLeft(width);

  String styled(List<AnsiStyle> styles, [AnsiColor? color]) {
    String text = this;

    for (final AnsiStyle style in styles) {
      switch (style) {
        case AnsiStyle.colored:
          if (color != null) {
            text = text.colored(color);
          }
          break;

        case AnsiStyle.bold:
          text = text.bold();
          break;

        case AnsiStyle.italic:
          text = text.italic();
          break;

        case AnsiStyle.underline:
          text = text.underline();
          break;

        case AnsiStyle.blinking:
          text = text.blinking();
          break;

        case AnsiStyle.strikethrough:
          text = text.strikethrough();
          break;
      }
    }

    if (color != null && !styles.contains(AnsiStyle.colored)) {
      text = text.colored(color);
    }

    return text;
  }

  String black() => colored(AnsiColor.black);

  String red() => colored(AnsiColor.red);

  String green() => colored(AnsiColor.green);

  String yellow() => colored(AnsiColor.yellow);

  String blue() => colored(AnsiColor.blue);

  String magenta() => colored(AnsiColor.magenta);

  String cyan() => colored(AnsiColor.cyan);

  String white() => colored(AnsiColor.white);

  String brightBlack() => colored(AnsiColor.brightBlack);

  String brightRed() => colored(AnsiColor.brightRed);

  String brightGreen() => colored(AnsiColor.brightGreen);

  String brightYellow() => colored(AnsiColor.brightYellow);

  String brightBlue() => colored(AnsiColor.brightBlue);

  String brightMagenta() => colored(AnsiColor.brightMagenta);

  String brightCyan() => colored(AnsiColor.brightCyan);

  String brightWhite() => colored(AnsiColor.brightWhite);
}

enum HorizontalLineStyle {
  single('─'),
  bold('━'),
  double('═'),
  dash('-');

  /// Default constructor of [HorizontalLineStyle]
  const HorizontalLineStyle(this.value);

  final String value;
}

class Ansi {
  static String horizontalLine({
    final int length = 50,
    final HorizontalLineStyle style = HorizontalLineStyle.single,
  }) {
    return style.value * length;
  }
}
