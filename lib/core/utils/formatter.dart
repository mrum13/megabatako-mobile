import 'package:money_formatter/money_formatter.dart';

String indonesiaCurrency({required String value}) {
  MoneyFormatter fmf = MoneyFormatter(
      amount: double.parse(value),
      settings: MoneyFormatterSettings(
          symbol: 'Rp.',
          thousandSeparator: '.',
          decimalSeparator: ',',
          symbolAndNumberSeparator: '',
          fractionDigits: 0,
          compactFormatType: CompactFormatType.short));

  MoneyFormatterOutput output = fmf.output;

  return output.symbolOnLeft;
}
