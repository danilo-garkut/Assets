package assets;

import java.util.*;

public class Assets
{
	public static void logContext(String label)
	{
		System.out.println
		(
			String.format
			( 
				">>>>>>(%s)@(%2$tH:%2$tM:%2$tS)on(%2$td/%2$tB/%2$tY)", 
				label, 
				Calendar.getInstance()
			)
		);
	}

	public static <T> void log(Collection<T> bundle, String label)
	{
		logContext(label);
		Iterator iter = bundle.iterator();
		while (iter.hasNext())
		{
			T t = (T) iter.next();
			log(t);
		}
	}

	public static <T> void log(Collection<T> bundle)
	{
		log(bundle, "");
	}

	public static <T> void log(T[] bundle, String label)
	{
		logContext(label);
		for (T t : bundle)
		{
			log(t);
		}
	}

	public static <T> void log(T[] bundle)
	{
		log(bundle, "");
	}

	public static <T> void log(T t, String label)
	{
		logContext(label);
		System.out.println(t);
	}

	public static <T> void log(T t)
	{
		System.out.println(t);
	}

}
