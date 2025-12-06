import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/room.dart';
import '../providers/user_provider.dart';
import '../widgets/loading_overlay.dart';
import '../widgets/common_elevated_button.dart';
import '../widgets/common_outlined_button.dart';
import 'chat_screen.dart';

class NameGenerationScreen extends StatefulWidget {
  final Room room;

  const NameGenerationScreen({super.key, required this.room});

  @override
  State<NameGenerationScreen> createState() => _NameGenerationScreenState();
}

class _NameGenerationScreenState extends State<NameGenerationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().initializeUser(widget.room);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        appBar: AppBar(
          title: Text('Room #${widget.room.code}'),
          leading: IconButton(
            icon: SvgPicture.asset('assets/images/back_button.svg'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.tertiary.withValues(alpha: .8),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 6,
                                spreadRadius: -4,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 15,
                                spreadRadius: -3,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                'For this room, you are',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Color(0xff9CA3AF)),
                              ),
                              const SizedBox(height: 16),

                              AnimatedScale(
                                scale: userProvider.regenerateLoading
                                    ? 0.9
                                    : 1.0,
                                duration: const Duration(milliseconds: 500),
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFFFDE047),
                                        AppColors.primary,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ).createShader(
                                      Rect.fromLTWH(
                                        0,
                                        0,
                                        bounds.width,
                                        bounds.height,
                                      ),
                                    );
                                  },
                                  blendMode: BlendMode.srcIn,
                                  child: Text(
                                    userProvider.currentUser?.displayName ??
                                        'Generating...',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 59,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),
                              Text(
                                'This is your anonymous identifier, visible only to others in this room',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Color(0xffD1D5DB)),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        if (userProvider.error != null)
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
                                userProvider.error!,
                                style: const TextStyle(
                                  color: AppColors.error,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonElevatedButton(
                              label: 'Acknowledge and continue',
                              onPressed: userProvider.currentUser != null
                                  ? () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            room: widget.room,
                                            user: userProvider.currentUser!,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              isLoading: false,
                            ),
                            const SizedBox(height: 20),
                            CommonOutlinedButton(
                              label: 'Regenerate',
                              onPressed: () =>
                                  userProvider.generateNewUser(widget.room),
                              isLoading: userProvider.regenerateLoading,
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                LoadingOverlay(
                  isLoading: userProvider.regenerateLoading,
                  message: 'Generating your identity...',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
