import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/code_input_field.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _maskFormatter = MaskTextInputFormatter(mask: '+7 ### ###-##-##', filter: {"#": RegExp(r'[0-9]')});
  bool _isLoading = false;
  bool _showCodeInput = false;
  String _sentPhone = '';
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.text = '+7 ';
    _phoneController.selection = TextSelection.collapsed(offset: _phoneController.text.length);

    _phoneController.addListener(_updatePhoneValidation);
  }

  @override
  void dispose() {
    _phoneController.removeListener(_updatePhoneValidation);
    _phoneController.dispose();
    super.dispose();
  }

  void _updatePhoneValidation() {
    final isValid = _isValidPhone(_phoneController.text);
    if (_isPhoneValid != isValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  void _requestCode() async {
    final maskedPhone = _phoneController.text;
    if (!_isValidPhone(maskedPhone)) return;

    // Очищаем номер от всего, кроме цифр
    final cleanedPhone = maskedPhone.replaceAll(RegExp(r'\D'), '');
    // Форматируем как +7...
    final phoneToSend = '+$cleanedPhone'; // → "+79001234567"

    setState(() => _isLoading = true);
    try {
      await ApiService.requestCode(phoneToSend); // ← Отправляем чистый номер
      setState(() {
        _sentPhone = phoneToSend; // Сохраняем именно тот номер, что ушёл на сервер
        _showCodeInput = true;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ошибка отправки кода')));
      setState(() => _isLoading = false);
    }
  }

  bool _isValidPhone(String maskedPhone) {
    // Удаляем всё, кроме цифр
    final cleaned = maskedPhone.replaceAll(RegExp(r'\D'), '');
    // Должно быть ровно 11 цифр: 79001234567
    return cleaned.length == 11 && cleaned.startsWith('7');
  }

  void _verifyCode(String code) async {
    setState(() => _isLoading = true);
    try {
      // Гарантируем, что номер в формате +79001234567
      String normalizedPhone = _sentPhone;

      // Если вдруг там остались нецифровые символы (кроме + в начале) — очищаем
      if (!normalizedPhone.startsWith('+')) {
        // Если по какой-то причине нет '+', добавляем
        final digitsOnly = normalizedPhone.replaceAll(RegExp(r'\D'), '');
        normalizedPhone = '+$digitsOnly';
      } else {
        // Убираем всё, кроме '+' и цифр
        final digitsPart = normalizedPhone.substring(1).replaceAll(RegExp(r'\D'), '');
        normalizedPhone = '+$digitsPart';
      }

      // Убедимся, что длина правильная: +7 + 10 цифр = 12 символов
      if (normalizedPhone.length != 12 || !normalizedPhone.startsWith('+7')) {
        throw Exception('Invalid phone format');
      }

      final token = await ApiService.verifyCode(normalizedPhone, code);
      await AuthService.saveToken(token);
      Navigator.of(context).pushReplacementNamed('/main');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Неверный код')));
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFF3B82F6),
                child: Icon(Icons.phone_android, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 24),
              const Text('Добро пожаловать!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const Text('Войдите в свой аккаунт по номеру телефона', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B))),

              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _phoneController,
                      inputFormatters: [_maskFormatter],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Номер телефона',
                        prefixIcon: Container(
                          alignment: Alignment.center,
                          width: 56, // ширина как у иконки
                          child: const Text('RU', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed:_isPhoneValid ? _requestCode : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Получить код', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              if (_showCodeInput)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    margin: const EdgeInsets.only(top: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        const Text('SMS-код', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 24),
                        CodeInputField(onCompleted: _verifyCode),
                        const SizedBox(height: 24),
                        Text('Код отправлен на номер\n$_sentPhone', textAlign: TextAlign.center),
                        TextButton(onPressed: _requestCode, child: const Text('Отправить повторно')),
                        ElevatedButton(
                          onPressed: () {}, // логика в CodeInputField
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Войти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDBEAFE)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.shield, color: Color(0xFF3B82F6)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Мы не передаём ваш номер телефона третьим лицам и используем его только для аутентификации',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text.rich(
                TextSpan(
                  text: 'Нажимая "Получить код", вы соглашаетесь с ',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  children: [
                    TextSpan(text: 'Условиями использования', style: TextStyle(color: Color(0xFF3B82F6))),
                    TextSpan(text: ' и ', style: TextStyle(color: Color(0xFF64748B))),
                    TextSpan(text: 'Политикой конфиденциальности', style: TextStyle(color: Color(0xFF3B82F6))),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}