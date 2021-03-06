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
	
	СтруктураДанных = ПолучитьСтруктуруДанных();
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	НаборТестов.Добавить("РасчетСебестоимости");
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

//ОбщегоНазначенияУТ.ВыполнитьЗакрытиеМесяца
Функция ПолучитьПараметрыРасчета(Организация = Неопределено)

	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	Если Организация = Неопределено Тогда
		Организация = Справочники.Организации.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ПараметрыЗакрытия.ЗакрываемыйПериод
	|ИЗ
	|	РегистрСведений.РегламентныеЗаданияЗакрытияМесяца КАК ПараметрыЗакрытия
	|ГДЕ
	|	ПараметрыЗакрытия.Организация = &Организация
	|");
	Запрос.УстановитьПараметр("Организация", Организация);
	Результат = Запрос.Выполнить();
	
	ЗакрываемыйПериод = Дата("00010101000000");
	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЗакрываемыйПериод = ВыборкаДетальныеЗаписи.ЗакрываемыйПериод;
	КонецЦикла;
	
	СписокОрганизаций = Новый Массив();
	Если ЗначениеЗаполнено(Организация) Тогда
		СписокОрганизаций.Добавить(Организация);
	КонецЕсли;
	
	МассивОпераций = Новый Массив();
	//++ НЕ УТ
	Для Каждого Значение Из Перечисления.ТипыРегламентныхОпераций Цикл
		Если Значение <> Перечисления.ТипыРегламентныхОпераций.ЗакрытиеГода Тогда
			МассивОпераций.Добавить(Значение);
		ИначеЕсли КонецМесяца(ЗакрываемыйПериод) = КонецГода(ЗакрываемыйПериод) Тогда // надо закрыть год
			МассивОпераций.Добавить(ЗакрываемыйПериод);
		КонецЕсли;
	КонецЦикла;
	//-- НЕ УТ
	
	ПараметрыРасчета = Новый Структура("СписокОрганизаций, Организация, ПериодРегистрации, Период, МассивОпераций, АдресХранилища");
	ПараметрыРасчета.СписокОрганизаций = СписокОрганизаций;
	ПараметрыРасчета.Организация = Организация;
	ПараметрыРасчета.ПериодРегистрации = ЗакрываемыйПериод;
	ПараметрыРасчета.Период = ЗакрываемыйПериод;
	ПараметрыРасчета.МассивОпераций = МассивОпераций;
	ПараметрыРасчета.АдресХранилища = Неопределено;
	
	Возврат ПараметрыРасчета;
	//ЗакрытиеМесяцаУТВызовСервера.РассчитатьВФоновомЗадании(ПараметрыРасчета);
	
КонецФункции

Процедура РасчетСебестоимости() Экспорт
	
	Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
	Запись.ЗакрываемыйПериод = '2016-01-01';
	Запись.Организация       = СтруктураДанных.Организация;
	Запись.Период            = ТекущаяДата();
	Запись.Записать();
	
	ПартионныйУчет.РассчитатьВсе(КонецМесяца('2016-01-01'), СтруктураДанных.Организация);
	
	//ПараметрыРасчета = ПолучитьПараметрыРасчета(СтруктураДанных.Организация);
	//ЗакрытиеМесяцаУТВызовСервера.РассчитатьЭтапы(ПараметрыРасчета);
	
КонецПроцедуры	

Функция ПолучитьСтруктуруДанных()
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Данные");
	
	Возврат Структура;
	
КонецФункции




