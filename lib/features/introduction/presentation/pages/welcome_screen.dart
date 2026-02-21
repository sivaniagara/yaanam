import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaanam/features/introduction/presentation/widgets/brand_name.dart';
import 'package:yaanam/features/introduction/presentation/widgets/brand_quotes.dart';

import '../../../../core/constant/app_images.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.5,
                  child: SvgPicture.asset(
                    AppImages.redMap,
                    height: MediaQuery.of(context).size.height * 1.2,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            Theme.of(context).colorScheme.primary,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter
                      )
                  ),
                ),
              ),
              Positioned(
                top: -20,
                child: Opacity(
                  opacity: 0.4 ,
                  child: Image.asset(
                      AppImages.welcomeStatue,
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome to', style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, color: Colors.black),),
                        BrandName(fontSize: 56,),
                        Text(
                            'Life Is Adventure Make The Best Of It',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                        backgroundColor: WidgetStateProperty.all(Color(0xffCD807B)),
                        shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              side: BorderSide(width: 1, color: Colors.white)
                            )
                        ),
                      ),
                        onPressed: (){
                          context.go('/signUp');
                        },
                        child: Text('Start with email or phone', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),)
                    ),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),),
                        TextButton(
                          onPressed: () {
                            context.go('/signIn');
                          },
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white,                        // text color
                              decoration: TextDecoration.underline,       // underline
                              decorationColor: Colors.white,              // underline color
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}
