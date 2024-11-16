import 'dart:math' show pi, sin;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet_example/widgets/cute_button.dart';
import 'package:wtf_sdk/wtf_sdk.dart';

// Add this enum at the top level
enum NounceEmotion {
  balance,
  loading,
  happy,
  sad,
}

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200], // or any color you want
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NounceEmotion _currentEmotion = NounceEmotion.balance;
  Widget? bubbleWidget;
  final _textController = TextEditingController();
  late WTF wtf;

  @override
  void initState() {
    super.initState();
    _currentEmotion = NounceEmotion.balance;
    final apiKey = dotenv.env['OPENAI_API_KEY'];

    // Initialize the WTF SDK with OpenAI for natural language processing
    wtf = WTF(
      aiModel: OpenAIModel(apiKey: apiKey!),
      blockchain: Blockchain(type: BlockchainType.ethereum, connectors: {
        BlockchainType.sui: SuiConnector(),
        BlockchainType.btc: BTCConnector(),
        BlockchainType.solana: SolanaConnector(),
        BlockchainType.kaspa: KaspaConnector(),
        BlockchainType.ethereum: EthereumConnector(),
        BlockchainType.tron: TronConnector(),
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 12),
            Text(
              'HIM/HER',
              textAlign: TextAlign.center,
              style: GoogleFonts.londrinaSolid(
                fontSize: 32,
                height: 1,
              ),
            ),
            const Text(
              'Your wallet agent',
              textAlign: TextAlign.center,
            ),
            Expanded(
              child: Center(
                child: NounceMan(
                    emotion: _currentEmotion, bubbleWidget: bubbleWidget),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (final emotion in NounceEmotion.values)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CuteButton(
                      borderRadius: 12,
                      onPressed: () {
                        setState(() {
                          _currentEmotion = emotion;
                          bubbleWidget = null;
                        });
                      },
                      label: (emotion.name.toUpperCase()),
                    ),
                  ),
              ],
            ),

            // 新增輸入框區域
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: 'wtf is going on...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF69B4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      onPressed: () async {
                        print(_textController.text);
                        final command = _textController.text;
                        _textController.clear();
                        setState(() {
                          _currentEmotion = NounceEmotion.loading;
                          bubbleWidget = Text(
                            '🤖 Parsing...',
                            style: GoogleFonts.londrinaSolid(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              height: 1,
                            ),
                          );
                        });

                        final request = await wtf.walletOperations
                            .processTransferCommand(command);
                        print('🤖 AI Parsed: ${request.toJson()}');

                        setState(() {
                          _currentEmotion = NounceEmotion.happy;
                          bubbleWidget = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To: ${request.recipientAddress.substring(0, 4)}...${request.recipientAddress.substring(request.recipientAddress.length - 4)}',
                                style: GoogleFonts.londrinaSolid(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              Text(
                                'Amount: ${request.amount} ${request.tokenSymbol}',
                                style: GoogleFonts.londrinaSolid(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  CuteButton(
                                    borderRadius: 12,
                                    onPressed: () {
                                      setState(() {
                                        bubbleWidget = null;
                                        _currentEmotion = NounceEmotion.balance;
                                      });
                                    },
                                    label: 'Cancel',
                                    backgroundColor: Colors.grey[300],
                                  ),
                                  const SizedBox(width: 8),
                                  CuteButton(
                                    borderRadius: 12,
                                    onPressed: () async {
                                      setState(() {
                                        bubbleWidget = Text(
                                          '🤖 Parsing...',
                                          style: GoogleFonts.londrinaSolid(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            height: 1,
                                          ),
                                        );
                                        _currentEmotion = NounceEmotion.loading;
                                        // Get AI-generated explanation of the transfer
                                      });
                                      final explanation = await wtf
                                          .walletOperations
                                          .explainTransfer(
                                        TransferResult(
                                          success: true,
                                          transactionHash:
                                              '0x902817fd0ae0f97b91315af257e1e7036437af4bd46dab32b795c4f9090c1299',
                                          details: {
                                            'tokenSymbol': request.tokenSymbol,
                                            'amount': request.amount,
                                            'senderAddress':
                                                '0x0a7a51B8887ca23B13d692eC8Cb1CCa4100eda4B',
                                            'recipientAddress':
                                                request.recipientAddress,
                                          },
                                        ),
                                      );

                                      setState(() {
                                        _currentEmotion = NounceEmotion.balance;
                                        bubbleWidget = Text(explanation);
                                      });
                                    },
                                    backgroundColor: Colors.green,
                                    label: 'Confirm',
                                  ),
                                ],
                              ),
                            ],
                          );
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}

class NounceMan extends StatefulWidget {
  const NounceMan({
    super.key,
    this.emotion = NounceEmotion.balance, // default to idle,
    required this.bubbleWidget,
  });
  final Widget? bubbleWidget;
  final NounceEmotion emotion;

  @override
  State<NounceMan> createState() => _NounceManState();
}

class _NounceManState extends State<NounceMan> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: switch (widget.emotion) {
                NounceEmotion.balance =>
                  const Color.fromARGB(255, 255, 202, 95),
                NounceEmotion.loading => Colors.blue[200],
                NounceEmotion.happy => Colors.green[200],
                NounceEmotion.sad => Colors.grey[300],
              },
              shape: BoxShape.circle,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.translate(
              offset: const Offset(0, -10),
              child: SvgPicture.asset(
                'assets/Noggles.svg',
                width: 80,
              ),
            ),
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            .custom(
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                switch (widget.emotion) {
                  case NounceEmotion.balance:
                    // Gentle bounce
                    return Transform.translate(
                      offset: Offset(0, value * 4),
                      child: child,
                    );
                  case NounceEmotion.loading:
                    // Tilt side to side
                    return Transform.rotate(
                      angle: sin(value * pi * 2) * 0.1,
                      child: child,
                    );
                  case NounceEmotion.happy:
                    // Bounce and spin slightly
                    return Transform.translate(
                      offset: Offset(0, sin(value * pi * 2) * 6),
                      child: Transform.rotate(
                        angle: sin(value * pi * 2) * 0.05,
                        child: child,
                      ),
                    );
                  case NounceEmotion.sad:
                    // Slow, subtle droop
                    return Transform.translate(
                      offset: Offset(0, sin(value * pi) * 2),
                      child: Transform.rotate(
                        angle: 0.1,
                        child: child,
                      ),
                    );
                }
              },
            ),
        if (widget.bubbleWidget != null)
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, -120),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: widget.bubbleWidget,
                      ),
                      Positioned(
                        bottom: -7,
                        left: 180,
                        child: CustomPaint(
                          size: const Size(16, 8),
                          painter: BubbleTailPainter(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class BubbleTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class TokenBubble extends StatelessWidget {
  const TokenBubble({super.key, required this.token, required this.amount});
  final String token;
  final String amount;

  @override
  Widget build(BuildContext context) {
    var imageUrl = switch (token) {
      "USDC" =>
        "https://cdn3d.iconscout.com/3d/premium/thumb/usdc-3d-icon-download-in-png-blend-fbx-gltf-file-formats--bitcoin-logo-crypto-coin-cryptocurrency-pack-logos-icons-8263869.png?f=webp",
      "ETH" =>
        "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Ethereum-icon-purple.svg/2048px-Ethereum-icon-purple.svg.png",
      String() => "",
    };
    return Row(
      children: [
        Image.network(imageUrl, width: 24),
        const SizedBox(width: 8),
        Text(
          "$amount $token",
          style: GoogleFonts.hankenGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
