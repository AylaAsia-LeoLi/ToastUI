//
//  MyDemo.swift
//  ToastUISample
//
//  Created by 李果洲 on 2021/5/19.
//

import Foundation
import SwiftUI

struct MyToastDemoShow: View {
  @State
  var isHudShow = false
  @State
  var isAlertShow = false
  @State
  var isShowPage1 = false
  @State
  var hudMessage = "首页默认提示"
    var body: some View {
      NavigationView(content: {
        VStack{
          Text("这个是首页")
          Button(action: {
            isAlertShow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              withAnimation(Animation.spring()){
                isHudShow = true
              }
            }
          }, label: {
            Text("2个一起显示ALERT-HUD")
          })
          Button(action: {
            isAlertShow = true
          }, label: {
            Text("显示弹框")
          })
          Button(action: {
            isHudShow = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
              withAnimation(Animation.spring()){
                isAlertShow = true
              }
            }
          }, label: {
            Text("2个一起显示HUD-ALERT")
          })
          Button(action: {isHudShow = true}, label: {
            Text("显示toast")
          })
          NavigationLink(
            destination: Page1ToastDemoShow(isHomeHudShow: $isHudShow, isShowPage1: $isShowPage1, isHomeAlertShow: $isAlertShow),
            isActive: $isShowPage1,
            label: {
              Text("我要跳转到page2")
            })
        }.toast(isPresented: $isHudShow, dismissAfter: 3.0, isHud: true) {

        } content: {
          HUDToast(message: $hudMessage)
        }
        .toast(isPresented: $isAlertShow,isHud: false) {

          Button(action: {isAlertShow = false}, label: {
            Text("page0")
          }).frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
          .background(Color.red)
        }



      })
    }
}

struct Page1ToastDemoShow : View{
  @Binding
  var isHomeHudShow: Bool
  @Binding
  var isShowPage1: Bool
  @Binding
  var isHomeAlertShow: Bool
  @State
  var isHudShow = false
  @State
  var isAlertShow = false
  @State
  var isShowPage2 = false
  @State
  var hudMessage = "page1默认提示"
  var body: some View {

    VStack{
      Text("这个是page1")
      Button(action: {

        isAlertShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isHudShow = true
          }
        }
      }, label: {
        Text("2个一起显示ALERT-HUD")
      })
      Button(action: {
        isAlertShow = true
      }, label: {
        Text("显示弹框")
      })
      Button(action: {
        isHudShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isAlertShow = true
          }
        }
      }, label: {
        Text("2个一起显示HUD-ALERT")
      })
      Button(action: {isHudShow = true}, label: {
        Text("显示toast")
      })
      NavigationLink(
        destination: Page2ToastDemoShow(isShowPage1: $isShowPage1, isPage1HudShow: $isHomeHudShow),
        isActive: $isShowPage2,
        label: {
          Text("我要跳转到page2")
        })
    }.toast(isPresented: $isHudShow, dismissAfter: 3.0, isHud: true) {

    } content: {
      HUDToast(message: $hudMessage)
    }
    .toast(isPresented: $isAlertShow,isHud: false) {
      Button(action: {isAlertShow = false}, label: {
        Text("page1")
      }).frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
      .background(Color.red)
    }
  }
}
struct Page2ToastDemoShow : View{
  @Binding
  var isShowPage1: Bool
  @Binding
  var isPage1HudShow: Bool
  @State
  var isHudShow = false
  @State
  var isAlertShow = false
  @State
  var isShowPage3 = false
  @State
  var hudMessage = "page2默认提示"
  var body: some View {

    VStack{
      Text("这个是page2")
      Button(action: {

        isAlertShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isHudShow = true
          }
        }
      }, label: {
        Text("2个一起显示ALERT-HUD")
      })
      Button(action: {
        isAlertShow = true
      }, label: {
        Text("显示弹框")
      })
      Button(action: {
        isHudShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isAlertShow = true
          }
        }
      }, label: {
        Text("2个一起显示HUD-ALERT")
      })
      Button(action: {isHudShow = true}, label: {
        Text("显示toast")
      })
      Button(action: {
        isShowPage1 = false
        isPage1HudShow = true
      }, label: {
        Text("显示两个弹框然后回到page1")
      })
      NavigationLink(
        destination: Page3ToastDemoShow(isShowPage1: $isShowPage1, isPage1HudShow: $isPage1HudShow),
        isActive: $isShowPage3,
        label: {
          Text("我要跳转到page3")
        })
    }.toast(isPresented: $isHudShow, dismissAfter: 3.0, isHud: true) {

    } content: {
      HUDToast(message: $hudMessage)
    }
    .toast(isPresented: $isAlertShow,isHud: false) {
      Button(action: {isAlertShow = false}, label: {
        Text("page2")
      }).frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
      .background(Color.red)
    }

  }
}

struct Page3ToastDemoShow : View{
  @Binding
  var isShowPage1: Bool
  @Binding
  var isPage1HudShow: Bool
  @State
  var isHudShow = false
  @State
  var isAlertShow = false
  @State
  var isShowPage4 = false
  @State
  var hudMessage = "page3默认提示"
  var body: some View {

    VStack{
      Text("这个是page3")
      Button(action: {

        isAlertShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isHudShow = true
          }
        }
      }, label: {
        Text("2个一起显示ALERT-HUD")
      })
      Button(action: {
        isAlertShow = true
      }, label: {
        Text("显示弹框")
      })
      Button(action: {
        isHudShow = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
          withAnimation(Animation.spring()){
            isAlertShow = true
          }
        }
      }, label: {
        Text("2个一起显示HUD-ALERT")
      })
      Button(action: {isHudShow = true}, label: {
        Text("显示toast")
      })
      Button(action: {
        isShowPage1 = false
        isPage1HudShow = true
      }, label: {
        Text("显示hud然后回到page1")
      })
      NavigationLink(
        destination: Text("Destination"),
        isActive: $isShowPage4,
        label: {
          Text("我要跳转到page4")
        })
    }.toast(isPresented: $isHudShow, dismissAfter: 3.0, isHud: true) {

    } content: {
      HUDToast(message: $hudMessage)
    }
    .toast(isPresented: $isAlertShow,isHud: false) {
      Button(action: {isAlertShow = false}, label: {
        Text("page3")
      }).frame(width: 300, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
      .background(Color.red)
    }

  }
}
struct HUDToast: View {
  var message:Binding<String>

  var body: some View {
    Text(message.wrappedValue)
      .foregroundColor(Color.gray)
      .aylaH4
      .padding(30)
      .background(Color.black.opacity(0.7))
      .cornerRadius(8)

  }
}
extension Text {
  var aylaH4: Text {
    self
      .font(.system(size: 16, weight: .semibold))
  }
}
struct MyToastDemoShow_Previews: PreviewProvider {
    static var previews: some View {
        MyToastDemoShow()
    }
}
