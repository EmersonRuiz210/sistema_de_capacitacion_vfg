// PANTALLA DE CHAT CON IA
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../utils/colors.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _mensajeController = TextEditingController();
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> _mensajes = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    // Mensaje de bienvenida
    _mensajes.add({
      'esUsuario': false,
      'texto':
          '¡Hola! 👋 Soy tu asistente de capacitación VFG. '
          'Puedo ayudarte con dudas sobre:\n\n'
          '💼 Educación Financiera\n'
          '🌱 Capacitación Ambiental\n'
          '✨ Empoderamiento Bíblico\n\n'
          '¿En qué puedo ayudarte hoy?',
    });
  }

  @override
  void dispose() {
    _mensajeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _enviarMensaje() async {
    final texto = _mensajeController.text.trim();
    if (texto.isEmpty || _cargando) return;

    setState(() {
      _mensajes.add({'esUsuario': true, 'texto': texto});
      _cargando = true;
    });

    _mensajeController.clear();
    _scrollToBottom();

    try {
      final respuesta = await ApiService.chatIA(texto);
      if (!mounted) return;
      setState(() {
        _mensajes.add({'esUsuario': false, 'texto': respuesta});
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _mensajes.add({
          'esUsuario': false,
          'texto': '⚠️ Error: ${e.toString().replaceAll('Exception: ', '')}',
          'error': true,
        });
        _cargando = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistente IA'),
        foregroundColor: AppColors.primaryBlue,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F6FA), Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _mensajes.length + (_cargando ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _mensajes.length && _cargando) {
                    return _buildTypingIndicator();
                  }
                  return _buildMensaje(_mensajes[index]);
                },
              ),
            ),
            // Input de texto
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMensaje(Map<String, dynamic> mensaje) {
    final esUsuario = mensaje['esUsuario'] == true;
    final esError = mensaje['error'] == true;

    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: esUsuario
              ? AppColors.primaryBlue
              : esError
              ? Colors.red[50]
              : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(esUsuario ? 16 : 4),
            bottomRight: Radius.circular(esUsuario ? 4 : 16),
          ),
          border: esUsuario
              ? null
              : Border.all(
                  color: esError ? Colors.red[200]! : Colors.grey[200]!,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          mensaje['texto'] ?? '',
          style: TextStyle(
            color: esUsuario
                ? Colors.white
                : esError
                ? Colors.red[800]
                : Colors.black87,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text('Pensando...', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _mensajeController,
                enabled: !_cargando,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _enviarMensaje(),
                decoration: InputDecoration(
                  hintText: 'Escribe tu pregunta...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: AppColors.primaryBlue),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: _cargando
                  ? Colors.grey[300]
                  : AppColors.primaryBlue,
              child: IconButton(
                icon: Icon(
                  _cargando ? Icons.hourglass_empty : Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _cargando ? null : _enviarMensaje,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
