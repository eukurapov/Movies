//
//  MockData.swift
//  Movies
//
//  Created by Eugene Kurapov on 09.11.2020.
//

import Foundation

struct MockData {
    
    static let collections: [Collection] = [
        
        Collection(name: "Сериалы",
                   movies: [Movie](repeating: Movie(
                                    name: "Друзья",
                                    subtitle: "Сколько бы раз вы ни посмотрели этот сериал, каждый раз вы будете смеяться",
                                    description: "Лауреат «Золотого глобуса», культовый американский ситком о шестерых друзьях, которые ищут свой путь в жизни. Моника (Кортни Кокс), Рэйчел (Дженнифер Энистон), Фиби (Лиза Кудроу), Росс (Дэвид Швиммер), Чендлер (Мэттью Перри) и Джоуи (Мэтт ЛеБлан) — закадычные друзья, с которыми постоянно что-то случается. Они ищут работу, терпят неудачи, испытывают судьбу на прочность, влюбляются, женятся, разводятся, но при этом живут по соседству и всегда готовы подставить дружеское плечо.",
                                    imagePath: "https://static.okko.tv/images/v2/7878125?presetId=4000&width=1136&quality=80&mediaType=jpeg",
                                    rate: 4.7
                                    ),
                                   count: 10)),
        
        Collection(name: "Рекомендации",
                   movies: [Movie](repeating: Movie(
                                    name: "Джентльмены",
                                    subtitle: "Отчаянная криминальная комедия от Гая Ричи со звёздным составом",
                                    description: "Мэттью МакКонахи, Колин Фаррел и Хью Грант показывают, как не испачкаться даже в самых грязных делах. Герои Гая Ричи остепенились, но не растеряли сноровки. Теперь они наставляют молодое поколение в криминальной комедии о джентльменах с манерами и гангстерах с кличками. Микки Пирсон (Мэтьью МакКонахи) — владелец цветущего и баснословно-дорогого бизнеса. Заручившись поддержкой английских лордов, он оборудовал 18 подпольных конопляных ферм. Единственное, чего не хватает Микки — доброго имени, и ради него он готов остепениться, прикупить себе имение и отойти от дел. Но стоит ему найти покупателя, как проблемы начинают расти как грибы: журналисты, мафиози, лорды с их проблемными отпрысками и даже дворовая шпана норовят сорвать сделку.",
                                    imagePath: "https://static.okko.tv/images/v2/9233982?presetId=4000&width=1136&quality=80&mediaType=jpeg",
                                    rate: 4.2
                   ),
                                   count: 12)),
        
        Collection(name: "Смотрите по подписке",
                   movies: [Movie](repeating: Movie(
                                    name: "Основатель",
                                    subtitle: "Реальная история создания сети быстрого питания Макдоналдс",
                                    description: "Как создавалась самая известная в мире сеть ресторанов Макдоналдс? Зрителю предстоит узнать яркую и загадочную историю Рэя Крока, который из продавца-неудачника превратился в миллиардера и легенду. \n\nOkko — это тысячи популярных фильмов, сериалов и самых свежих новинок. Смотрите фильм «Основатель» (The Founder, 2016) онлайн в отличном качестве (Full HD 1080) с профессиональной озвучкой на русском языке или с субтитрами.",
                                    imagePath: "https://static.okko.tv/images/v2/10319245?presetId=4000&width=1136&quality=80&mediaType=jpeg",
                                    rate: 3.6
                   ),
                                   count: 20)),
        
    ]
    
}
