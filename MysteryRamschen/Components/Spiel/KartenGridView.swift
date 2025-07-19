import SwiftUI

struct KartenGridView: View {
 
    let karten : [String] = ["pik7","herzA"]
    
    var body: some View{
        HStack{
            
            ForEach(karten, id:  \.self){ karte in
                
                Image(karte)
                    .resizable()
                    .frame(width: 130, height: 200)
            }
        }
    }
    
    
}


#Preview {
    KartenGridView()
}
