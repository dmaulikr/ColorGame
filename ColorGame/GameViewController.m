//
//  GameViewController.m
//  ColorGame
//
//  Created by iOS Developer on 2013. 12. 1..
//  Copyright (c) 2013년 iOS Developer. All rights reserved.
//

#import "GameViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GameOverViewController.h"

@interface GameViewController ()

@end

@implementation GameViewController

@synthesize time;
@synthesize gametimer;
@synthesize timer;
@synthesize frenzylogictimer;
@synthesize realR, realG, realB, Ra, Ga, Ba, Rv, Gv, Bv, directionB,directionG,directionR,directionRv,directionGv,directionBv;

@synthesize question;
@synthesize Opt1setting;
@synthesize Opt2setting;
@synthesize Opt3setting;
@synthesize Opt4setting;

@synthesize sort1, sort2, sort3, sort4;
@synthesize score;
@synthesize scorelabel;
@synthesize health;

@synthesize HP1, HP2, HP3;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//game time
/*
- (void) awakeFromNib
{
    time = 50;
    
}
 */
//그냥 viewdidload에서 해도 되지 않나


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    Ra=0, Ga=0, Ba=0, Rv=0, Gv=0, Bv=0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    timeattacksetting = [defaults objectForKey:@"TimeattackSetting"];
    
    if([timeattacksetting intValue]!=1)
    {
        time=50;
    }
    else
    {
        time=20;
    }
    
    //timer api
    gametimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updatetime) userInfo:nil repeats:YES];
    int temp=time;
    timer.text = [NSString stringWithFormat:@"%i", temp];
    [self GameLogic];
    score=0;
    scorelabel.text=[NSString stringWithFormat:@"%i", score];
    health=3;
    
    //If settings are enabled, use frenzy mode
    
    NSNumber *FrenzySetting = [defaults objectForKey:@"FrenzySetting"];
    
    
    
    //realR=1, realG=1, realB=1;
    //메인메뉴에서 이어지는 것으로 수정되면서 삭제. 메인메뉴 변화가 더럽다고 생각되면 다시 부활 예정.
    
    //Code modified: Frenzy only when TimeAttack is off
    if([FrenzySetting intValue]==1&&[timeattacksetting intValue]!=1)
    {
    frenzylogictimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(frenzytime) userInfo:nil repeats:YES];
    }
    
    //TimeAttack mode background change
    if([timeattacksetting intValue]==1)
    {
        extratime=3;
        if([FrenzySetting intValue]==1)
        timeattackbackgroundtimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timeattackbackgroundlogic) userInfo:nil repeats:YES];
    }
}

//timer logic
- (void) updatetime
{
    time = time - 0.03;
    if (time <=0)
    {
        [gametimer invalidate];
        
        //INSERT GAME OVER CODE
        
        [self GameOver];
        
        
    }
    int temp=time;
    timer.text = [NSString stringWithFormat:@"%i", temp];
}

- (void) frenzytime
{
    if (time <=0)
    {
        [frenzylogictimer invalidate];
    }
    
    
    float a=arc4random()%1000;
    float b=arc4random()%1000;
    float c=arc4random()%1000;
    
    if(Ra>=0.01)
        directionRv=1;
    if(Ra<=0.008)
        directionRv=0;
    if(directionRv==0)
        Ra+=a/1000000;
    if(directionRv==1)
        Ra-=a/1000000;
    
    if(Ga>=0.01)
        directionGv=1;
    if(Ga<=0.008)
        directionGv=0;
    if(directionGv==0)
        Ga+=b/1000000;
    if(directionGv==1)
        Ga-=b/1000000;
    
    if(Ba>=0.01)
        directionBv=1;
    if(Ba<=0.008)
        directionBv=0;
    if(directionBv==0)
        Ba+=c/1000000;
    if(directionBv==1)
        Ba-=c/1000000;
    
    Rv=Ra*0.7;
    Gv=Ga*0.8;
    Bv=Ba*0.9;
    
    
    
    if(realR>=0.9)
        directionR=1;
    if(realR<=0.1)
        directionR=0;
    if(directionR==0)
        realR+=Rv;
    if(directionR==1)
        realR-=Rv;
    
    if(realG>=0.9)
        directionG=1;
    if(realG<=0.1)
        directionG=0;
    if(directionG==0)
        realG+=Gv;
    if(directionG==1)
        realG-=Gv;
    
    if(realB>=0.9)
        directionB=1;
    if(realB<=0.1)
        directionB=0;
    if(directionB==0)
        realB+=Bv;
    if(directionG==1)
        realB-=Bv;
    
    
    self.view.backgroundColor=[UIColor colorWithRed:realR green:realG blue:realB alpha:1];
    

}

//시간 줄어들수록 화면 변화
- (void) timeattackbackgroundlogic
{
    if (time<=0)
    {
        [timeattackbackgroundtimer invalidate];
    }
    else
    {
        float R, G, B;
 
        if(time>20)
        {
            R=1;
            G=1;
            B=1;
        }
        else if(time>=0.04)
        {
            R=(float)time/20;
            G=(float)time/20;
            B=(float)time/20;
        }
        else
        {
            R=0.04;
            G=0.04;
            B=0.04;
        }
        
        
        self.view.backgroundColor=[UIColor colorWithRed:R green:G blue:B alpha:1];
    }
}

//추가 시간 부여 로직
- (void) giveExtraTime
{
    if(extratime>=0.5)
    {
        extratime=extratime-0.1;
    }
    time=time+extratime;
    int temp=time;
    timer.text = [NSString stringWithFormat:@"%d", temp];
}


- (void) GameLogic
{
    int randomtext=arc4random()%7, randomcolor=arc4random()%7;
    int trueanswertext=arc4random()%7, trueanswercolor=arc4random()%7;
    int falseanswer1text=arc4random()%7, falseanswer1color=arc4random()%7, falseanswer2text=arc4random()%7, falseanswer2color=arc4random()%7, falseanswer3text=arc4random()%7, falseanswer3color=arc4random()%7;
    
    sort1=arc4random()%4+1, sort2=arc4random()%4+1, sort3=arc4random()%4+1, sort4=arc4random()%4+1;
    
    //정답 배열 랜덤화
    while(sort2==sort1)
    {
        sort2=arc4random()%4+1;
    }
    while(sort3==sort2||sort3==sort1)
    {
        sort3=arc4random()%4+1;
    }
    while(sort4==sort3||sort4==sort2||sort4==sort1)
    {
        sort4=arc4random()%4+1;
    }
    
    
    //문제의 색과 글씨 다르게 설정
    while(randomcolor==randomtext)
    {
        randomcolor=arc4random()%7;
    }
    
    //혹시 모를 시간차 대비, 숨기기
    [question setHidden:YES];
    [Opt1setting setHidden:YES];
    [Opt2setting setHidden:YES];
    [Opt3setting setHidden:YES];
    [Opt4setting setHidden:YES];
    
    //문제의 색과 글씨 다르게 실제로 주입
    question.text=[self ReturnColorText:randomtext];
    question.textColor=[self ReturnColorValue:randomcolor];
    
    //옳은 보기의 글씨는 문제의 실제 색과 같아야 한다
    trueanswertext=randomcolor;
    
    
    //옳은 보기의 색과 글씨 다르게 설정 (문제의 색과 글씨가, 옳은 보기의 색과 글씨가 달라야 헷갈린다.)
    while(trueanswercolor==trueanswertext)
    {
        trueanswercolor=arc4random()%7;
    }
    
    //다른 보기의 글씨는 옳은 보기의 글씨와 같으면 안된다! (복수정답 예방)
    while(falseanswer1text==trueanswertext)
    {
        falseanswer1text=arc4random()%7;
    }
    while(falseanswer2text==trueanswertext||falseanswer2text==falseanswer1text)
    {
        falseanswer2text=arc4random()%7;
    }
    while(falseanswer3text==trueanswertext||falseanswer3text==falseanswer2text||falseanswer3text==falseanswer1text)
    {
        falseanswer3text=arc4random()%7;
    }
    
    
    
    //버전1: 다른 보기의 색과 글씨가 달라야 한다
    //한계점: 같은 색이 많이 보여서 좀 안 예쁘다
    /*
    while(falseanswer1color==falseanswer1text)
    {
        falseanswer1color=arc4random()%7;
    }
    
    while(falseanswer2color==falseanswer2text)
    {
        falseanswer2color=arc4random()%7;
    }
    
    while(falseanswer3color==falseanswer3text)
    {
        falseanswer3color=arc4random()%7;
    }
    */
    
    
    
    //버전2: 보기의 색깔은 예뻐야 한다(...)
    //한계점: 글씨와 색깔이 같은 경우가 있다
    while(falseanswer1color==trueanswercolor)
    {
        falseanswer1color=arc4random()%7;
    }
    while(falseanswer2color==falseanswer1color||falseanswer2color==trueanswercolor)
    {
        falseanswer2color=arc4random()%7;
    }
    while(falseanswer3color==falseanswer2color||falseanswer3color==falseanswer1color||falseanswer3color==trueanswercolor)
    {
        falseanswer3color=arc4random()%7;
    }
    
    
    //아직 간소화할 방법 찾지 못함: 보기 랜덤 배열. 로직은, sort 1~4는 각각 버튼 1~4에 대응되는데, sort의 실제값이 보기를 집어넣게 된다.
    //즉, sort1==3이면 3번 보기가 1번에 들어가며, sort2==1이면 (1번 보기, 즉 정답)이 2번에 들어간다.
    switch (sort1)
    {
        case 1:
            [Opt1setting setTitle:[self ReturnColorText:trueanswertext] forState:(UIControlStateNormal)];
            [Opt1setting setTitleColor:[self ReturnColorValue:trueanswercolor] forState:(UIControlStateNormal)];
            break;
        case 2:
            [Opt1setting setTitle:[self ReturnColorText:falseanswer1text] forState:(UIControlStateNormal)];
            [Opt1setting setTitleColor:[self ReturnColorValue:falseanswer1color] forState:(UIControlStateNormal)];
            break;
        case 3:
            [Opt1setting setTitle:[self ReturnColorText:falseanswer2text] forState:(UIControlStateNormal)];
            [Opt1setting setTitleColor:[self ReturnColorValue:falseanswer2color] forState:(UIControlStateNormal)];
            break;
        case 4:
            [Opt1setting setTitle:[self ReturnColorText:falseanswer3text] forState:(UIControlStateNormal)];
            [Opt1setting setTitleColor:[self ReturnColorValue:falseanswer3color] forState:(UIControlStateNormal)];
            break;
    }
    switch (sort2)
    {
        case 1:
            [Opt2setting setTitle:[self ReturnColorText:trueanswertext] forState:(UIControlStateNormal)];
            [Opt2setting setTitleColor:[self ReturnColorValue:trueanswercolor] forState:(UIControlStateNormal)];
            break;
        case 2:
            [Opt2setting setTitle:[self ReturnColorText:falseanswer1text] forState:(UIControlStateNormal)];
            [Opt2setting setTitleColor:[self ReturnColorValue:falseanswer1color] forState:(UIControlStateNormal)];
            break;
        case 3:
            [Opt2setting setTitle:[self ReturnColorText:falseanswer2text] forState:(UIControlStateNormal)];
            [Opt2setting setTitleColor:[self ReturnColorValue:falseanswer2color] forState:(UIControlStateNormal)];
            break;
        case 4:
            [Opt2setting setTitle:[self ReturnColorText:falseanswer3text] forState:(UIControlStateNormal)];
            [Opt2setting setTitleColor:[self ReturnColorValue:falseanswer3color] forState:(UIControlStateNormal)];
            break;
    }
    switch (sort3)
    {
        case 1:
            [Opt3setting setTitle:[self ReturnColorText:trueanswertext] forState:(UIControlStateNormal)];
            [Opt3setting setTitleColor:[self ReturnColorValue:trueanswercolor] forState:(UIControlStateNormal)];
            break;
        case 2:
            [Opt3setting setTitle:[self ReturnColorText:falseanswer1text] forState:(UIControlStateNormal)];
            [Opt3setting setTitleColor:[self ReturnColorValue:falseanswer1color] forState:(UIControlStateNormal)];
            break;
        case 3:
            [Opt3setting setTitle:[self ReturnColorText:falseanswer2text] forState:(UIControlStateNormal)];
            [Opt3setting setTitleColor:[self ReturnColorValue:falseanswer2color] forState:(UIControlStateNormal)];
            break;
        case 4:
            [Opt3setting setTitle:[self ReturnColorText:falseanswer3text] forState:(UIControlStateNormal)];
            [Opt3setting setTitleColor:[self ReturnColorValue:falseanswer3color] forState:(UIControlStateNormal)];
            break;
    }
    switch (sort4)
    {
        case 1:
            [Opt4setting setTitle:[self ReturnColorText:trueanswertext] forState:(UIControlStateNormal)];
            [Opt4setting setTitleColor:[self ReturnColorValue:trueanswercolor] forState:(UIControlStateNormal)];
            break;
        case 2:
            [Opt4setting setTitle:[self ReturnColorText:falseanswer1text] forState:(UIControlStateNormal)];
            [Opt4setting setTitleColor:[self ReturnColorValue:falseanswer1color] forState:(UIControlStateNormal)];
            break;
        case 3:
            [Opt4setting setTitle:[self ReturnColorText:falseanswer2text] forState:(UIControlStateNormal)];
            [Opt4setting setTitleColor:[self ReturnColorValue:falseanswer2color] forState:(UIControlStateNormal)];
            break;
        case 4:
            [Opt4setting setTitle:[self ReturnColorText:falseanswer3text] forState:(UIControlStateNormal)];
            [Opt4setting setTitleColor:[self ReturnColorValue:falseanswer3color] forState:(UIControlStateNormal)];
            break;
    }
    
    //숨기기 취소
    [question setHidden:NO];
    [Opt1setting setHidden:NO];
    [Opt2setting setHidden:NO];
    [Opt3setting setHidden:NO];
    [Opt4setting setHidden:NO];
    /*
    int bg=arc4random()%7;
    while(bg==randomcolor||bg==trueanswercolor||bg==falseanswer1color||bg==falseanswer2color||bg==falseanswer3color)
    {
        bg=arc4random()&7;
    }
    
    self.view.backgroundColor = [self ReturnColorValue:bg];
     */
}


- (IBAction)Opt1
{
    if(sort1==1)
    {
        score++;
        
        //extra time
        if([timeattacksetting intValue]==1)
        {
            [self giveExtraTime];
        }
    }
    else
    {
        score--;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        if(health==1)
        {
            HP1.text=@"";
            health--;
            [self GameOver];
        }
        else if(health==2)
        {
            HP2.text=@"";
            health--;
        }
        else if(health==3)
        {
            HP3.text=@"";
            health--;
        }
    }
    scorelabel.text=[NSString stringWithFormat:@"%i", score];
    [self GameLogic];
    
    

    
}

- (IBAction)Opt2
{
    if(sort2==1)
    {
        score++;
        //extra time
        if([timeattacksetting intValue]==1)
        {
            [self giveExtraTime];
        }
    }
    else
    {
        score--;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        if(health==1)
        {
            HP1.text=@"";
            health--;
            [self GameOver];
        }
        else if(health==2)
        {
            HP2.text=@"";
            health--;
        }
        else if(health==3)
        {
            HP3.text=@"";
            health--;
        }

    }
    scorelabel.text=[NSString stringWithFormat:@"%i", score];
    [self GameLogic];
}

- (IBAction)Opt3
{
    if (sort3==1)
    {
        score++;
        //extra time
        if([timeattacksetting intValue]==1)
        {
            [self giveExtraTime];
        }
    }
    else
    {
        score--;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        if(health==1)
        {
            HP1.text=@"";
            health--;
            [self GameOver];
        }
        else if(health==2)
        {
            HP2.text=@"";
            health--;
        }
        else if(health==3)
        {
            HP3.text=@"";
            health--;
        }

    }
    
    scorelabel.text=[NSString stringWithFormat:@"%i", score];
    [self GameLogic];
}

- (IBAction)Opt4
{
    if(sort4==1)
    {
        score++;
        //extra time
        if([timeattacksetting intValue]==1)
        {
            [self giveExtraTime];
        }
    }
    else
    {
        score--;
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        if(health==1)
        {
            HP1.text=@"";
            health--;
            [self GameOver];
        }
        else if(health==2)
        {
            HP2.text=@"";
            health--;
        }
        else if(health==3)
        {
            HP3.text=@"";
            health--;
        }

    }
    scorelabel.text=[NSString stringWithFormat:@"%i", score];
    [self GameLogic];
}

- (NSString*)ReturnColorText:(int)i
{
    NSString* value;
    
    switch (i)
    {
        case 0: value=@"RED";
            break;
        case 1: value=@"GREEN";
            break;
        case 2: value=@"BLUE";
            break;
        case 3: value=@"BLACK";
            break;
        case 4: value=@"YELLOW";
            break;
        case 5: value=@"PURPLE";
            break;
        case 6: value=@"SILVER";
    }
    return value;
}

- (UIColor*)ReturnColorValue:(int)i
{
    UIColor* value;
    
    switch (i)
    {
        case 0: value = [UIColor redColor];
            break;
        case 1: value = [UIColor greenColor];
            break;
        case 2: value = [UIColor blueColor];
            break;
        case 3: value = [UIColor blackColor];
            break;
        case 4: value = [UIColor yellowColor];
            break;
        case 5: value = [UIColor purpleColor];
            break;
        case 6: value = [UIColor colorWithRed:0.854 green:0.854 blue:0.854 alpha:1];
    }
    return value;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GameOver
{
    
    //Achievements and game center high score
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *FrenzySetting = [defaults objectForKey:@"FrenzySetting"];
    
    if(score>0&&[FrenzySetting intValue]==1)
    {
        score*=1.1;
    }
    

    if(score==-3)
    {
        NSNumber *under_achiever = [defaults objectForKey:@"Under_Achiever"];
        if([[GameCenterManager sharedManager] progressForAchievement:@"Under_Achiever"]!=100||[under_achiever intValue]!=1)
        {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"Under_Achiever" percentComplete:100 shouldDisplayNotification:YES];
        }
        else
        {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"Under_Achiever" percentComplete:100 shouldDisplayNotification:NO];
        }
        under_achiever=[NSNumber numberWithInt:1];
        [defaults setObject:under_achiever forKey:@"Under_Achiever"];
        [defaults synchronize];
        
    }
    if(score==0)
    {
        NSNumber *risk_aversion = [defaults objectForKey:@"Risk_Aversion"];
        
        if([[GameCenterManager sharedManager] progressForAchievement:@"Risk_Aversion"]!=100||[risk_aversion intValue]!=1)
        {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"Risk_Aversion" percentComplete:100 shouldDisplayNotification:YES];
        }
        else
        {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"Risk_Aversion" percentComplete:100 shouldDisplayNotification:NO];
        }
        
        risk_aversion=[NSNumber numberWithInt:1];
        [defaults setObject:risk_aversion forKey:@"Risk_Aversion"];
        [defaults synchronize];
    }
    if(score==42)
    {
        NSNumber *meaning_of_life = [defaults objectForKey:@"Meaning_of_life"];
        
        if([[GameCenterManager sharedManager] progressForAchievement:@"Meaning_of_life"]!=100||[meaning_of_life intValue]!=1)
        {
            [[GameCenterManager sharedManager] saveAndReportAchievement:@"Meaning_of_life" percentComplete:100 shouldDisplayNotification:YES];
        }
        else
        {
        [[GameCenterManager sharedManager] saveAndReportAchievement:@"Meaning_of_life" percentComplete:100 shouldDisplayNotification:NO];
        }
        
        meaning_of_life=[NSNumber numberWithInt:1];
        [defaults setObject:meaning_of_life forKey:@"Risk_Aversion"];
        [defaults synchronize];
    }
    
    //Load local highscore, compare, and save new highscore if necessary
    
    NSNumber *highscore;
    if([timeattacksetting intValue]!=1)
    {
        highscore = [defaults objectForKey:@"normalhigh"];
        if(score>[highscore intValue])
        {
            NSNumber *scoretosave=[NSNumber numberWithInt:score];
            [defaults setObject:scoretosave forKey:@"normalhigh"];
            [defaults synchronize];
            //without the code below, the highscore will only be updated next time, because NSNumber highscore is based on previous value
            highscore = [NSNumber numberWithInt:score];
        }
        [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:@"1" sortOrder:GameCenterSortOrderHighToLow];
    }
    else
    {
        highscore = [defaults objectForKey:@"timeattackhigh"];
        if(score>[highscore intValue])
        {
            NSNumber *scoretosave=[NSNumber numberWithInt:score];
            [defaults setObject:scoretosave forKey:@"timeattackhigh"];
            [defaults synchronize];
            //without the code below, the highscore will only be updated next time, because NSNumber highscore is based on previous value
            highscore = [NSNumber numberWithInt:score];
        }
        [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:@"2" sortOrder:GameCenterSortOrderHighToLow];
    }
    
    GameOverViewController *GameOverViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    GameOverViewController.score=[NSString stringWithFormat:@"%i", score];
    GameOverViewController.highscore=[highscore intValue];
    [self presentViewController:GameOverViewController animated:YES completion:nil];
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}




@end
