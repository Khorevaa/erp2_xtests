﻿Перем КонтекстЯдра;
Перем Ожидаем;
Перем Утверждения;
Перем ГенераторТестовыхДанных;
Перем ЗапросыИзБД;
Перем УтвержденияПроверкаТаблиц;

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
	
	НаборТестов.НачатьГруппу("ПроизводствоРабот", Истина);
	НаборТестов.Добавить("УдалитьДокументы");
	НаборТестов.Добавить("Спецификация");
	НаборТестов.Добавить("ЗаказНаПроизводство");
	НаборТестов.Добавить("ПланированиеПроизводства");
	НаборТестов.Добавить("МаршрутныйЛист");
	НаборТестов.Добавить("ПоступлениеТоваров");
	НаборТестов.Добавить("ПеремещениеНаСкладПроизводства");
	НаборТестов.Добавить("ВыполнениеМаршрутногоЛиста");
	НаборТестов.Добавить("ВыпускПродукции");
	НаборТестов.Добавить("ПередачаМатериаловВПроизводство");
	// Блок ЗП
	НаборТестов.Добавить("ПриемНаРаботу");
	НаборТестов.Добавить("ФормированиеСоставаБригады");
	НаборТестов.Добавить("ВыработкаСотрудников");
	НаборТестов.Добавить("НачислениеЗарплаты");
	НаборТестов.Добавить("ОтражениеЗПвБУ");
	//
	НаборТестов.Добавить("АктВыполненныхРабот");
	НаборТестов.Добавить("СчетФактура");
	НаборТестов.Добавить("РасчетСебестоимости");
	НаборТестов.Добавить("ОСВ");
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	
КонецПроцедуры

Функция РазрешенСлучайныйПорядокВыполненияТестов() Экспорт
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область Тест

Процедура УдалитьДокументы() Экспорт
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	УдалитьДокументыПоОрганизации(Структура.Организация);
	
	КонтекстЯдра.СохранитьКонтекст(Структура);
	
КонецПроцедуры	

Процедура Спецификация() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Спецификация");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ЗаказНаПроизводство
Процедура ЗаказНаПроизводство() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ЗаказНаПроизводство");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	ДокументОбъект = СтруктураДанных.ЗаказНаПроизводствоГП1.ПолучитьОбъект();
	
	КэшированныеЗначения = Неопределено;
	МассивДанных = Новый Массив;
	Для каждого СтрокаТЧ из ДокументОбъект.Продукция Цикл
		МассивДанных.Добавить(ДанныеПоНоменклатуре(СтрокаТЧ, ДокументОбъект));
	КонецЦикла;	
	
	ПланированиеПроизводства.ЗаполнитьДанныеСпецификаций(ДокументОбъект, МассивДанных, КэшированныеЗначения);
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

Функция ДанныеПоНоменклатуре(ДанныеСтроки, РеквизитыЗаказа)
	
	ДанныеПоНоменклатуре = Новый Структура;
	
	ДанныеПоНоменклатуре.Вставить("КлючСвязиПродукция",     ДанныеСтроки.КлючСвязи);
	ДанныеПоНоменклатуре.Вставить("Номенклатура",           ДанныеСтроки.Номенклатура);
	ДанныеПоНоменклатуре.Вставить("Характеристика",         ДанныеСтроки.Характеристика);
	ДанныеПоНоменклатуре.Вставить("Склад",                  ДанныеСтроки.Склад);
	ДанныеПоНоменклатуре.Вставить("Подразделение",          ДанныеСтроки.Подразделение);
	ДанныеПоНоменклатуре.Вставить("Спецификация",           ДанныеСтроки.Спецификация);
	ДанныеПоНоменклатуре.Вставить("Количество",             ДанныеСтроки.Количество);
	ДанныеПоНоменклатуре.Вставить("Упаковка",               ДанныеСтроки.Упаковка);
	ДанныеПоНоменклатуре.Вставить("НачалоПроизводства",     ДанныеСтроки.НачатьНеРанее);
	ДанныеПоНоменклатуре.Вставить("ДатаПотребности",        ДанныеСтроки.НачатьНеРанее);
	ДанныеПоНоменклатуре.Вставить("КлючСвязиПолуфабрикат");
	ДанныеПоНоменклатуре.Вставить("КлючСвязиЭтапы");
	
	ДанныеПоНоменклатуре.Вставить("Назначение",             ДанныеСтроки.Назначение);
	ДанныеПоНоменклатуре.Вставить("НазначениеЗаказа",       РеквизитыЗаказа.Назначение);
	
	ДанныеПоНоменклатуре.Вставить("ПодразделениеДиспетчер", РеквизитыЗаказа.Подразделение);
	
	Возврат ДанныеПоНоменклатуре;
	
КонецФункции

//ПланированиеПроизводства
Процедура ПланированиеПроизводства() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	КонецЕсли;	
	
	РассчитатьГрафикПоЗаказу(СтруктураДанных.ЗаказНаПроизводствоГП1);
	СкорректироватьДатыПоЗаказу(СтруктураДанных.ЗаказНаПроизводствоГП1);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

Процедура РассчитатьГрафикПоЗаказу(ЗаказНаПроизводство) Экспорт
	
	Результат = ПланированиеПроизводстваВызовСервера.РассчитатьГрафикВыпуска(ЗаказНаПроизводство);
	
	// ПланированиеПроизводстваКлиент.ПланироватьОчередьЗаказов()
	Если НЕ Результат.Запланирован Тогда
		
		Для каждого Ошибка из Результат.Ошибки Цикл
			
			ТекстСообщения = "";
			
			Если ТипЗнч(Ошибка.ВидыРабочихЦентров) = Тип("Массив") Тогда
				
				Для каждого ВидРабочегоЦентра из Ошибка.ВидыРабочихЦентров Цикл
					
					ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Доступности вида рабочего центра %1 недостаточно для размещения этапа.'"),
						ВидРабочегоЦентра.НаименованиеВидаРабочегоЦентра);
					
					ВызватьИсключение ТекстСообщения;
					
				КонецЦикла;
				
			Иначе
				
				ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Не установлен график, по которому работает подразделение %1.'"),
					Ошибка.ВидыРабочихЦентров);
					
					ВызватьИсключение ТекстСообщения;
					
			КонецЕсли;
				
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура СкорректироватьДатыПоЗаказу(ЗаказНаПроизводство) Экспорт
	
	ЗаказОбъект = ЗаказНаПроизводство.ПолучитьОбъект();
	Если Ложь Тогда
		ЗаказОбъект = Документы.Данные.СоздатьДокумент();
	КонецЕсли;
	
	Для каждого СтрокаТЧ из ЗаказОбъект.ПродукцияГрафик Цикл
		СтрокаТЧ.Начало    = '2016-01-01';
		СтрокаТЧ.Окончание = '2016-01-25';
	КонецЦикла;
	
	Для каждого СтрокаТЧ из ЗаказОбъект.ЭтапыГрафик Цикл
		
		СтрокаТЧ.НачалоПредварительногоБуфера = '2016-01-01';
		СтрокаТЧ.ОкончаниеЗавершающегоБуфера  = '2016-01-25';
		
		СтрокаТЧ.НачалоЭтапа    = '2016-01-01';
		СтрокаТЧ.ОкончаниеЭтапа = '2016-01-25';
		
	КонецЦикла;
	
	Для каждого СтрокаТЧ из ЗаказОбъект.ВыходныеИзделияГрафик Цикл
		СтрокаТЧ.ДатаЗапуска = '2016-01-01';
		СтрокаТЧ.ДатаВыпуска = '2016-01-25';
	КонецЦикла;	
	
	Для каждого СтрокаТЧ из ЗаказОбъект.ВозвратныеОтходыГрафик Цикл
		СтрокаТЧ.ДатаВыпуска = '2016-01-25';
	КонецЦикла;	
	
	Для каждого СтрокаТЧ из ЗаказОбъект.МатериалыИУслугиГрафик Цикл
		СтрокаТЧ.ДатаПотребности = '2016-01-01';
	КонецЦикла;	
	
	Для каждого СтрокаТЧ из ЗаказОбъект.ТрудозатратыГрафик Цикл
		СтрокаТЧ.ДатаПотребности = '2016-01-01';
	КонецЦикла;	
	
	ЗаказОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры

//МаршрутныйЛист
Процедура МаршрутныйЛист() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	КонецЕсли;	
	
	МассивЗаказов = Новый Массив;
	МассивЗаказов.Добавить(СтруктураДанных.ЗаказНаПроизводствоГП1);
	Результат = ОперативныйУчетПроизводстваВызовСервера.СформироватьМаршрутныеЛистыПоЗаказам(МассивЗаказов);
	Если НЕ Результат.Выполнено Тогда
		//ВызватьИсключение "Маршрутный лист на ГП сформирован";
	КонецЕсли;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ПоступлениеТоваров
Процедура ПоступлениеТоваров() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ПТУ");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.ПоступлениеТоваровИУслуг1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ПеремещениеНаСкладПроизводства
Процедура ПеремещениеНаСкладПроизводства() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Перемещение");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.Перемещение1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ВыполнениеМаршрутногоЛиста
Процедура ВыполнениеМаршрутногоЛиста() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	КонецЕсли;	
	
	МассивМаршрутныхЛистов = ПолучитьМассивМаршрутныхЛистов(СтруктураДанных.ЗаказНаПроизводствоГП1);
	
	Для каждого МаршрутныйЛист из МассивМаршрутныхЛистов Цикл
		УстановитьОтметкиМаршрутногоЛиста(МаршрутныйЛист);
	КонецЦикла;	
	
	СтруктураДанных.Вставить("МассивМаршрутныхЛистов", МассивМаршрутныхЛистов);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

Процедура УстановитьОтметкиМаршрутногоЛиста(МаршрутныйЛист) Экспорт
	
	ДокументОбъект = МаршрутныйЛист.ПолучитьОбъект();
	Если Ложь Тогда
		ДокументОбъект = Документы.МаршрутныйЛистПроизводства.СоздатьДокумент();
	КонецЕсли;	
	
	ДокументОбъект.Дата   = '2016-01-01';
	ДокументОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполняется;
	ДокументОбъект.ПриИзмененииСтатуса(, '2016-01-01');
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	Если ДокументОбъект.Трудозатраты.Количество() > 0 Тогда
		ДокументОбъект.Трудозатраты[0].Бригада = Справочники.Бригады.НайтиПоНаименованию("Бригада (Авто-тест)");
	//	ДокументОбъект.Трудозатраты[0].КоличествоФакт = 0;
	//	ДокументОбъект.Трудозатраты[0].КоличествоОтклонение = -ДокументОбъект.Трудозатраты[0].Количество;
	КонецЕсли;	
	
	ДокументОбъект.Статус = Перечисления.СтатусыМаршрутныхЛистовПроизводства.Выполнен;
	ДокументОбъект.ПриИзмененииСтатуса(, '2016-01-25');
	
	Если ДокументОбъект.ФактическоеОкончание = НачалоДня(ДокументОбъект.ФактическоеОкончание) Тогда
		ДокументОбъект.ФактическоеОкончание = ДокументОбъект.ФактическоеОкончание + 1;
	КонецЕсли;	
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры	

Функция ПолучитьМассивМаршрутныхЛистов(МассивЗаказов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивЗаказов", МассивЗаказов);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства КАК Док
	|ГДЕ
	|	Док.Распоряжение В (&МассивЗаказов)";
	
	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции	

//ВыпускПродукции
Процедура ВыпускПродукции() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
		
		МассивМаршрутныхЛистов = ПолучитьМассивМаршрутныхЛистов(СтруктураДанных.ЗаказНаПроизводствоГП1);
		СтруктураДанных.Вставить("МассивМаршрутныхЛистов", МассивМаршрутныхЛистов);
		
	КонецЕсли;	
	
	// ВводНаОснованииУТКлиент.СоздатьНаОснованииМаршрутныхЛистов
	МассивСсылок = СтруктураДанных.МассивМаршрутныхЛистов;
	
	ТекстПредупреждения = Неопределено;
	ПараметрыОформления = Документы.ВыпускПродукции.ПараметрыОформленияВыпуска(МассивСсылок, Неопределено, ТекстПредупреждения);
	Если ПараметрыОформления = Неопределено Тогда
		//Проверять не будем. Если есть, то перезаполним
		ВызватьИсключение ТекстПредупреждения;
	КонецЕсли;
	
	ДокументОбъект = Документы.ВыпускПродукции.СоздатьДокумент();
	ДокументОбъект.Заполнить(СтруктураДанных.МассивМаршрутныхЛистов[0]);
	ДокументОбъект.Дата = '2016-01-31';
	
	Утверждения.ПроверитьРавенство(ДокументОбъект.Товары.Количество(), 1, "В документе Выпуск продукциидолжно быть 1 строка");
	
	Для каждого СтрокаТЧ из ДокументОбъект.Товары Цикл
		
		Если СтрокаТЧ.ТипСтоимости = Перечисления.ТипыСтоимостиВыходныхИзделий.Фиксированная Тогда
			СтрокаТЧ.Цена  = СтрокаТЧ.НомерСтроки * 10;
			СтрокаТЧ.Сумма = СтрокаТЧ.Количество * СтрокаТЧ.Цена;
		КонецЕсли;	
		
	КонецЦикла;	
	
	ДокументОбъект.Записать();
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры

//ПередачаМатериаловВПроизводство
Процедура ПередачаМатериаловВПроизводство() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	ПередачаМатериаловПоПодразделению(СтруктураДанных);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

Процедура ПередачаМатериаловПоПодразделению(СтруктураДанных) Экспорт
	
	ПараметрыДанных = Новый Структура;
	ПараметрыДанных.Вставить("Организация",   СтруктураДанных.Организация);
	ПараметрыДанных.Вставить("Подразделение", СтруктураДанных.Подразделение1);
	ПараметрыДанных.Вставить("Склад",         СтруктураДанных.СкладПроизводство);
	ПараметрыДанных.Вставить("ЗаказыПоДату",  '0001-01-01');
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	Обработки.ПолучениеИВозвратМатериалов.ПолучитьДанные(ПараметрыДанных, АдресХранилища);
	
	Данные = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	РеквизитыШапки = Новый Структура;
	РеквизитыШапки.Вставить("Организация",   СтруктураДанных.Организация);
	РеквизитыШапки.Вставить("Подразделение", СтруктураДанных.Подразделение1);
	РеквизитыШапки.Вставить("Склад",         СтруктураДанных.СкладПроизводство);
	РеквизитыШапки.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаВПроизводство"));
	
	ДанныеДляЗаполненияТовары = Новый ТаблицаЗначений;
	ДанныеДляЗаполненияТовары.Колонки.Добавить("Номенклатура");
	ДанныеДляЗаполненияТовары.Колонки.Добавить("Характеристика");
	ДанныеДляЗаполненияТовары.Колонки.Добавить("КоличествоУпаковок");
	ДанныеДляЗаполненияТовары.Колонки.Добавить("Количество");
	ДанныеДляЗаполненияТовары.Колонки.Добавить("Назначение");
	ДанныеДляЗаполненияТовары.Колонки.Добавить("Серия");
	
	Для каждого ДанныеСтроки Из Данные Цикл
		ДанныеДляЗаполнения = ДанныеДляЗаполненияТовары.Добавить();
		ЗаполнитьЗначенияСвойств(ДанныеДляЗаполнения, ДанныеСтроки);
		
		ДанныеДляЗаполнения.Количество = -ДанныеСтроки.Остаток;
		ДанныеДляЗаполнения.КоличествоУпаковок = ДанныеДляЗаполнения.Количество;
	КонецЦикла;	
		
	ПараметрыОснования = Новый Структура;
	ПараметрыОснования.Вставить("Товары",         ДанныеДляЗаполненияТовары);
	ПараметрыОснования.Вставить("РеквизитыШапки", РеквизитыШапки);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Док.Ссылка
	|ИЗ
	|	Документ.ПередачаМатериаловВПроизводство КАК Док
	|ГДЕ
	|	Док.Организация = &Организация
	|	И Док.Подразделение = &Подразделение
	|	И Док.Склад = &Склад
	|	И НАЧАЛОПЕРИОДА(Док.Дата, ДЕНЬ) = &Дата
	|	И НЕ Док.ПометкаУдаления";
	
	Запрос.Параметры.Вставить("Организация",   СтруктураДанных.Организация);
	Запрос.Параметры.Вставить("Подразделение", СтруктураДанных.Подразделение1);
	Запрос.Параметры.Вставить("Склад",         СтруктураДанных.СкладПроизводство);
	Запрос.Параметры.Вставить("Дата",          '2016-01-31');
	
	Результат = Запрос.Выполнить();
	Если НЕ Результат.Пустой() Тогда
		ДокументСсылка = Результат.Выгрузить()[0].Ссылка;
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		
		ДокументОбъект.Товары.Очистить();
		ДокументОбъект.ВидыЗапасов.Очистить();
	Иначе	
		ДокументОбъект = Документы.ПередачаМатериаловВПроизводство.СоздатьДокумент();
	КонецЕсли;
	
	ДокументОбъект.Дата = '2016-01-31';
	ДокументОбъект.Заполнить(ПараметрыОснования);
	ДокументОбъект.ПотреблениеДляДеятельности = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС;
	ДокументОбъект.Статус = Перечисления.СтатусыПередачМатериаловВПроизводство.Принято;
	ДокументОбъект.Записать();
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);

КонецПроцедуры

//ПриемНаРаботу
Процедура ПриемНаРаботу() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ПриемНаРаботу");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.ПриемНаРаботу1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ФормированиеСоставаБригады
Процедура ФормированиеСоставаБригады() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ФормированиеСоставаБригады");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.ФормированиеСоставаБригады1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
	
		Попытка
			СтрокаТЧ = ДокументОбъект.Сотрудники[0];
			СтрокаТЧ._РольИсполнителяРабот = Справочники.ус_РолиИсполнителейРаботНаПередалах.НайтиПоНаименованию("Рабочий цеха");
		Исключение
		КонецПопытки;
		
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ВыработкаСотрудников
Процедура ВыработкаСотрудников() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
		
		МассивМаршрутныхЛистов = ПолучитьМассивМаршрутныхЛистов(СтруктураДанных.ЗаказНаПроизводствоГП1);
		СтруктураДанных.Вставить("МассивМаршрутныхЛистов", МассивМаршрутныхЛистов);
		
	КонецЕсли;	
	
	// ВводНаОснованииУТКлиент.СозданиеВыработкиСотрудников
	МассивСсылок = СтруктураДанных.МассивМаршрутныхЛистов;
	
	
	ТекстПредупреждения = Неопределено;
	ПараметрыОформления = ОперативныйУчетПроизводстваВызовСервера.ПараметрыОформленияВыработкиСотрудников(
									МассивСсылок,
									ТекстПредупреждения);
	Если ПараметрыОформления = Неопределено Тогда
		//Проверять не будем. Если есть, то перезаполним
		ВызватьИсключение ТекстПредупреждения;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СписокРаспоряжений", МассивСсылок);
	ПараметрыФормы.Вставить("ВидНаряда",     Перечисления.ВидыБригадныхНарядов.Производство);
	ПараметрыФормы.Вставить("Организация",   ПараметрыОформления.Организация);
	ПараметрыФормы.Вставить("Подразделение", ПараметрыОформления.Подразделение);
	
	ПараметрыФормы.Вставить("Бригада",       Справочники.Бригады.НайтиПоНаименованию("Бригада (Авто-тест)"));
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("МассивСсылок", МассивСсылок);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Док.ВидРабот
	|ИЗ
	|	Документ.МаршрутныйЛистПроизводства.Трудозатраты КАК Док
	|ГДЕ
	|	Док.Ссылка В(&МассивСсылок)";
	
	МассивВидовРабот = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидРабот");
	ПараметрыФормы.Вставить("МассивВидовРабот", МассивВидовРабот);
	
	ДокументОбъект = Документы.ВыработкаСотрудников.СоздатьДокумент();
	ДокументОбъект.Заполнить(ПараметрыФормы);
	ДокументОбъект.Дата = '2016-01-31';
	
	Если ДокументОбъект.ВидыРабот.Количество() = 0 Тогда
		ВызватьИсключение "Нет видов работ";
	КонецЕсли;	
	
	Попытка
		ДокументОбъект._ДлительностьРаботДокумента = 24;
	Исключение
	КонецПопытки;
	
	Документы.ВыработкаСотрудников.ЗаполнитьСотрудниковПоСоставуБригады(ДокументОбъект, Неопределено, Истина);
	Документы.ВыработкаСотрудников.РаспределитьРаботыПоКТУ(ДокументОбъект);
	
	Попытка
		СтрокаТЧ = ДокументОбъект.Сотрудники[0];
		СтрокаТЧ.НормативныйКТУ = 1;
	Исключение
	КонецПопытки;
	
	ДокументОбъект.Записать(РежимЗаписиДокумента.Запись);
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//НачислениеЗарплаты
Процедура НачислениеЗарплаты() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "НачислениеЗарплаты");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.РасчетНачислений1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//ОтражениеЗПвБУ
Процедура ОтражениеЗПвБУ() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "ОтражениеЗПвБУ");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.ОтражениеЗПвБУ1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//АктВыполненныхРабот
Процедура АктВыполненныхРабот() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = Новый Структура;
	КонецЕсли;	
	
	Структура = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "АктВыполненныхРабот");
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(СтруктураДанных, Структура, Истина);
	
	МассивДокументов = Новый Массив;
	МассивДокументов.Добавить(СтруктураДанных.Акт1);
	
	Для каждого ДокументСсылка из МассивДокументов Цикл
		ДокументОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	КонецЦикла;	
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//СчетФактура
Процедура СчетФактура() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Ссылки");
	КонецЕсли;	
	
	РеквизитыСчетаФактуры = Неопределено;
	ПараметрыОтбора = Новый Структура("Организация", СтруктураДанных.Организация);
	СчетаФактуры = Документы.СчетФактураВыданный.СчетаФактурыПоОснованию(СтруктураДанных.Акт1, ПараметрыОтбора, РеквизитыСчетаФактуры);
	
	Если СчетаФактуры.Количество() > 0 Тогда
		ДокументОбъект = РеквизитыСчетаФактуры.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ДокументыОснования.Очистить();
	Иначе
		ДокументОбъект = Документы.СчетФактураВыданный.СоздатьДокумент();
		ДокументОбъект.Дата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураДанных.Акт1, "Дата");
	КонецЕсли;	
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("ДокументОснование", СтруктураДанных.Акт1);
	ДанныеЗаполнения.Вставить("Организация",       СтруктураДанных.Организация);
	
	ДокументОбъект.Заполнить(ДанныеЗаполнения);
	ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
	СтруктураДанных.Вставить("СчетФактура", ДокументОбъект.Ссылка);
	
	КонтекстЯдра.СохранитьКонтекст(СтруктураДанных);
	
КонецПроцедуры	

//РасчетСебестоимости
Процедура РасчетСебестоимости() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	КонецЕсли;	
	
	Если НЕ СтруктураДанных.Свойство("Организация") Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	КонецЕсли;	
	
	ЗакрытьМесяц(СтруктураДанных.Организация);
	
	Результат = ПартииНезавершенногоПроизводства(СтруктураДанных.Организация, '2016-02-01');
	Утверждения.ПроверитьИстину(Результат, "Обнаружены остатки  по регистру ПартииНезавершенногоПроизводства");
	
	Результат = СебестоимостьТоваров(СтруктураДанных.Организация, '2016-02-01');
	Утверждения.ПроверитьИстину(Результат, "Обнаружены остатки  по регистру СебестоимостьТоваров");
	
КонецПроцедуры	

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

Процедура ЗакрытьМесяц(Организация)
	
	Запись = РегистрыСведений.РегламентныеЗаданияЗакрытияМесяца.СоздатьМенеджерЗаписи();
	Запись.ЗакрываемыйПериод = '2016-01-01';
	Запись.Организация       = Организация;
	Запись.Период            = ТекущаяДата();
	Запись.Записать();
	
	ПараметрыРасчета = ПолучитьПараметрыРасчета(Организация);
	ЗакрытиеМесяцаУТВызовСервера.РассчитатьЭтапы(ПараметрыРасчета);
	
КонецПроцедуры	

//ОСВ
Процедура ОСВ() Экспорт
	
	СтруктураДанных = КонтекстЯдра.ПолучитьКонтекст();
	Если СтруктураДанных = Неопределено Тогда
		СтруктураДанных = ГенераторТестовыхДанных.СоздатьДанныеПоМакетам(ЭтотОбъект, "Организация");
	КонецЕсли;	
	
	ТабДокОСВ = СформироватьОСВ(СтруктураДанных.Организация);
	ТабДокОригинал = ПолучитьМакет("ОСВ");
	
	УтвержденияПроверкаТаблиц.ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТабДокОСВ, ТабДокОригинал);
	
КонецПроцедуры	

#КонецОбласти

#Область Проверки

Функция ПартииНезавершенногоПроизводства(Организация, Период)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Период",        Период);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.Организация,
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.ВидЗапасов,
	|	Рег.ЗаказНаПроизводство,
	|	Рег.КодСтрокиПродукция,
	|	Рег.ДокументПоступления,
	|	Рег.Этап,
	|	Рег.СтатьяКалькуляции,
	|	Рег.АналитикаУчетаПартий,
	|	Рег.КоличествоОстаток,
	|	Рег.СтоимостьОстаток,
	|	Рег.СтоимостьБезНДСОстаток,
	|	Рег.СтоимостьРеглОстаток,
	|	Рег.НДСРеглОстаток,
	|	Рег.ПостояннаяРазницаОстаток,
	|	Рег.ВременнаяРазницаОстаток
	|ИЗ
	|	РегистрНакопления.ПартииНезавершенногоПроизводства.Остатки(&Период, Организация = &Организация) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

Функция СебестоимостьТоваров(Организация, Период)
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	Запрос.Параметры.Вставить("Период",      Период);
	Запрос.Параметры.Вставить("РазделУчета", Перечисления.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты);
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Рег.АналитикаУчетаНоменклатуры,
	|	Рег.РазделУчета,
	|	Рег.ВидЗапасов,
	|	Рег.Организация,
	|	Рег.КоличествоОстаток,
	|	Рег.СтоимостьОстаток,
	|	Рег.СтоимостьБезНДСОстаток,
	|	Рег.СуммаДопРасходовОстаток,
	|	Рег.СуммаДопРасходовБезНДСОстаток,
	|	Рег.СтоимостьРеглОстаток,
	|	Рег.ПостояннаяРазницаОстаток,
	|	Рег.ВременнаяРазницаОстаток
	|ИЗ
	|	РегистрНакопления.СебестоимостьТоваров.Остатки(
	|			&Период,
	|			Организация = &Организация
	|				И РазделУчета = &РазделУчета) КАК Рег";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;	
	
КонецФункции

Функция ПодготовитьПараметрыОтчета(Отчет)

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Организация"                      , Отчет.Организация);
	ПараметрыОтчета.Вставить("НачалоПериода"                    , Отчет.НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"                     , Отчет.КонецПериода);
	ПараметрыОтчета.Вставить("ВключатьОбособленныеПодразделения", Отчет.ВключатьОбособленныеПодразделения);
	ПараметрыОтчета.Вставить("ПоказательБУ"                     , Отчет.ПоказательБУ);
	ПараметрыОтчета.Вставить("ПоказательНУ"                     , Отчет.ПоказательНУ);
	ПараметрыОтчета.Вставить("ПоказательПР"                     , Отчет.ПоказательПР);
	ПараметрыОтчета.Вставить("ПоказательВР"                     , Отчет.ПоказательВР);
	ПараметрыОтчета.Вставить("ПоказательВалютнаяСумма"          , Мин(Отчет.ПоказательВалютнаяСумма, БухгалтерскийУчетПереопределяемый.ИспользоватьВалютныйУчет()));
	ПараметрыОтчета.Вставить("ПоказательКонтроль"               , Отчет.ПоказательКонтроль);
	ПараметрыОтчета.Вставить("ВыводитьЗабалансовыеСчета"        , Отчет.ВыводитьЗабалансовыеСчета);
	ПараметрыОтчета.Вставить("РазмещениеДополнительныхПолей"    , Отчет.РазмещениеДополнительныхПолей);
	ПараметрыОтчета.Вставить("ПоСубсчетам"                      , Отчет.ПоСубсчетам);
	ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ДополнительныеПоля"               , Отчет.ДополнительныеПоля.Выгрузить());
	ПараметрыОтчета.Вставить("РазвернутоеСальдо"                , Отчет.РазвернутоеСальдо.Выгрузить());
	ПараметрыОтчета.Вставить("РежимРасшифровки"                 , Отчет.РежимРасшифровки);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , Ложь);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , Ложь);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , Неопределено);
	ПараметрыОтчета.Вставить("МакетОформления"                  , Неопределено);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , Отчет.ПолучитьМакет("СхемаКомпоновкиДанных"));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , "ОборотноСальдоваяВедомость");
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты[ПараметрыОтчета.ИдентификаторОтчета].ПолучитьНаборПоказателей());
    ПараметрыОтчета.Вставить("ОтветственноеЛицо"                , Перечисления.ОтветственныеЛицаОрганизаций.ОтветственныйЗаБухгалтерскиеРегистры);
    ПараметрыОтчета.Вставить("ВыводитьЕдиницуИзмерения"         , Ложь);
	
	Возврат ПараметрыОтчета;

КонецФункции

Функция СформироватьОСВ(Организация)
	
	Отчет = Отчеты.ОборотноСальдоваяВедомость.Создать();
	
	Отчет.НачалоПериода = '2016-01-01';
	Отчет.КонецПериода  = КонецМесяца('2016-01-01');
	Отчет.Организация   = Организация;
	Отчет.ПоказательБУ  = Истина;
	Отчет.ПоСубсчетам   = Истина;
	
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", Ложь);
	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , Ложь);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(Отчет);
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено);
	БухгалтерскиеОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
	
	Струткра = ПолучитьИзВременногоХранилища(АдресХранилища);
	Возврат Струткра.Результат;
	
КонецФункции

#КонецОбласти

#Область УдалениеДокументов

Процедура УдалитьДокументыПоОрганизации(Организация)
	
	Таблица = Новый ТаблицаЗначений;
	Таблица.Колонки.Добавить("Имя");
	Таблица.Колонки.Добавить("Отбор");
	
	ДобавитьДокумент(Таблица, "Документ.РасчетСебестоимостиТоваров");
	ДобавитьДокумент(Таблица, "Документ.РегламентнаяОперация");
	ДобавитьДокумент(Таблица, "Документ.ПереоценкаВалютныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученныйАванс");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданный");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураВыданныйАванс");
	ДобавитьДокумент(Таблица, "Документ.ВзаимозачетЗадолженности");
	ДобавитьДокумент(Таблица, "Документ.РеализацияТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.СписаниеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеБезналичныхДенежныхСредств");
	ДобавитьДокумент(Таблица, "Документ.АктВыполненныхРабот");
	ДобавитьДокумент(Таблица, "Документ.РаспределениеПроизводственныхЗатрат");
	ДобавитьДокумент(Таблица, "Документ.СборкаТоваров");
	ДобавитьДокумент(Таблица, "Документ.ВыработкаСотрудников");
	ДобавитьДокумент(Таблица, "Документ.ВыпускПродукции");
	ДобавитьДокумент(Таблица, "Документ.ПередачаМатериаловВПроизводство");
	ДобавитьДокумент(Таблица, "Документ.ПеремещениеТоваров");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПеремещение");
	ДобавитьДокумент(Таблица, "Документ.МаршрутныйЛистПроизводства");
	ДобавитьДокумент(Таблица, "Документ.СчетФактураПолученный");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеТоваровУслуг");
	ДобавитьДокумент(Таблица, "Документ.ПоступлениеУслугПрочихАктивов");
	ДобавитьДокумент(Таблица, "Документ.ПриемНаРаботу");
	ДобавитьДокумент(Таблица, "Документ.НачислениеЗарплаты");
	ДобавитьДокумент(Таблица, "Документ.ОтражениеЗарплатыВФинансовомУчете");
	ДобавитьДокумент(Таблица, "Документ.ЗаказНаПроизводство");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Док.Ссылка
	|ИЗ
	|	Документ.АвансовыйОтчет КАК Док
	|ГДЕ
	|	Док.Организация = &Организация";
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("Организация", Организация);
	
	Для каждого СтрокаТЗ из Таблица Цикл
		
		Текст1 = СтрЗаменить(ТекстЗапроса, "Документ.АвансовыйОтчет", СтрокаТЗ.Имя);
		Текст1 = СтрЗаменить(Текст1, "Док.Организация", СтрокаТЗ.Отбор);
		
		Запрос.Текст = Текст1;
		ТаблицаДокументов = Запрос.Выполнить().Выгрузить();
		Для каждого Строка1 из ТаблицаДокументов Цикл
			
			Объект = Строка1.Ссылка.ПолучитьОбъект();
			
			Если Объект <> Неопределено Тогда
				
				Попытка
					Объект.Удалить();
				Исключение
					//Сообщить(Строка(ТипЗнч(Объект)) + ": " + Строка(Объект));
				КонецПопытки;
				
			КонецЕсли;	
					
		КонецЦикла;	
		
	КонецЦикла;	
	
КонецПроцедуры	

Процедура ДобавитьДокумент(Таблица, Имя, Отбор = "Организация")
	
	НоваяСтрока = Таблица.Добавить();
	НоваяСтрока.Имя   = Имя;
	НоваяСтрока.Отбор = Отбор;
	
КонецПроцедуры	

#КонецОбласти

