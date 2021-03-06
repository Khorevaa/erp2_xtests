﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

Перем СтруктураДанных;

#Область ЮнитТестирование

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	ГенераторТестовыхДанных = КонтекстЯдра.Плагин("СериализаторMXL");
	ЗапросыИзБД = КонтекстЯдра.Плагин("ЗапросыИзБД");
	УтвержденияПроверкаТаблиц = КонтекстЯдра.Плагин("УтвержденияПроверкаТаблиц");
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("ПТУ");
	НаборТестов.Добавить("СчетФактура");
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

Процедура ПТУ() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ПТУ");
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(Структура.ПоступлениеТоваровИУслуг1);
	МассивДокументов.Добавить(Структура.ПоступлениеТоваровИУслуг2);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		
		РеквизитыДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДокументСсылка, "Дата, Организация");
		СтруктураРеквизиты = Новый Структура("Ссылка, Дата, Организация", ДокументСсылка, РеквизитыДокумента.Дата, РеквизитыДокумента.Организация);
		РеглУчетПроведениеСервер.ОтразитьДокумент(СтруктураРеквизиты, Истина);
		
	КонецЦикла;	
	
КонецПроцедуры

Процедура СчетФактура() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "СчетФактуры");
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(Структура.СчФ1);
	МассивДокументов.Добавить(Структура.СчФ2);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
КонецПроцедуры

