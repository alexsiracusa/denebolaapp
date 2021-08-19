//
//  AboutText.swift
//  DenebolaApp
//
//  Created by Alex Siracusa on 5/27/21.
//

import SwiftUI

struct AboutText: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 5) {
                Text("About")
                    .font(.title)
                    .bold()
                Text("""
                Named after one of the brightest stars in the Leo constellation, Denebola is Newton South High School’s official online newspaper. Converting from a print publication in 2012, Denebola possesses a storied heritage of award-winning news reporting that caters to South students and Newton community members alike. With sections ranging from school news to sports to our proprietary “Procrastinate Here” section, we strive to provide reliable, informative, and relative news and entertainment to the Newton community and beyond.

                Denebola has a single, unifying goal: To represent you, a fellow student at South. As an extracurricular club, Denebola aims to highlight students in school activities and to highlight our communities accomplishments as well as give students a voice.

                Since converting to online, Denebola has been recognized for:
                2013 NSPA Pacemaker award winner
                Featured in NSPA 19 “Best of High School Press”
                2013, 2014, 2015, 2016 and 2017 first place in “Excellence in Online Journalism” from Suffolk University
                2014, 2015, 2016, 2018, 2019 – first place in “ALL – New England” in journalism from the New England Scholastic Press Association
                2015 & 2021 “Highest Achievement” in journalism from the New England Scholastic Press Association
                2016 NSPA “Best in Show” 10th Place
                2017 NSPA “Best in Show” 6th Place
                2018 & 2019 Honorable Mention in “Excellence in Online Journalism” – Suffolk University

                And for a variety of individual awards:
                MASPA – Feature Photo of the Year (First place, 2018); Sports Photo of the Year (Third Place, 2018), Online Video of the Year (Second Place, 2018)
                """)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
    }
}

struct AboutText_Previews: PreviewProvider {
    static var previews: some View {
        AboutText()
    }
}
