import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { useSession, useSupabaseClient } from "@supabase/auth-helpers-react";
import { useEffect } from "react";
import { useRouter } from "next/router";

const Home = () => {
  const router = useRouter();
  const session = useSession();
  const supabase = useSupabaseClient();
  useEffect(() => {
    if (session) {
      router.push("/dashboard");
    }
  }, [session]);
  useEffect(() => {
    const { data: authListener } = supabase.auth.onAuthStateChange(
      async (event, session) => {
        if (event === "SIGNED_IN") {
          console.log("signed in");
          router.push("/dashboard");
        } else if (event === "SIGNED_OUT") {
          router.push("/");
        }
      }
    );
    return () => {
      authListener.subscription.unsubscribe();
    };
  }, []);

  return (
    <div className="auth">
      <div className="authcontainer" style={{ padding: "100px 0 100px 0" }}>
        {!session ? (
          <Auth
            providers={["google", "github"]}
            supabaseClient={supabase}
            appearance={{ theme: ThemeSupa,
              logo: "https://raw.githubusercontent.com/supabase/supabase/master/web/static/supabase-light.svg" }}
            theme="dark"
          />
        ) : (
          <div className="loading-screen">
            <div className="dot"></div>
            <div className="dot"></div>
            <div className="dot"></div>
            <div className="dot"></div>
            <div className="dot"></div>
          </div>
        )}
      </div>
    </div>
  );
};

export default Home;
