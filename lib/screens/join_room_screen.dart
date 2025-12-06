import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/room_provider.dart';
import '../widgets/common_elevated_button.dart';
import '../widgets/common_outlined_button.dart';
import 'name_generation_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _roomCodeController = TextEditingController();

  @override
  void dispose() {
    _roomCodeController.dispose();
    super.dispose();
  }

  Future<void> _joinRoom(BuildContext context) async {
    final roomProvider = context.read<RoomProvider>();
    final navigator = Navigator.of(context);
    await roomProvider.joinRoom(_roomCodeController.text);

    if (!mounted) return;

    if (roomProvider.currentRoom != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) =>
              NameGenerationScreen(room: roomProvider.currentRoom!),
        ),
      );
    }
  }

  Future<void> _createRoom(BuildContext context) async {
    final roomProvider = context.read<RoomProvider>();
    final navigator = Navigator.of(context);
    await roomProvider.createRoom();

    if (!mounted) return;

    if (roomProvider.currentRoom != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) =>
              NameGenerationScreen(room: roomProvider.currentRoom!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RoomProvider>(
        builder: (context, roomProvider, child) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  SvgPicture.asset('assets/images/logo.svg'),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Join A Room',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xffFAFAFA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter the code to join the anon chat room',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xffA1A1AA),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _roomCodeController,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 12,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xff27272A),
                            hintText: '- - - - - -',
                            hintStyle: TextStyle(color: Color(0xffA1A1AA)),
                            counterText: '',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (roomProvider.error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.error.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: AppColors.error,
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                roomProvider.error!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        CommonElevatedButton(
                          label: 'Join Room',
                          onPressed: () => _joinRoom(context),
                          isLoading: roomProvider.joinLoading,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: AppColors.divider,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'or',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 0.5,
                                color: AppColors.divider,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CommonOutlinedButton(
                          label: 'Create New Room',
                          onPressed: () => _createRoom(context),
                          isLoading: roomProvider.createLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
