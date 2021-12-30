 % Do we update? */
if (update_foreground)

    st.Davg1 = 0;
    st.Davg2 = 0;
    st.Dvar1 = 0;
    st.Dvar2 = 0;
    st.foreground = st.W;
% Apply a smooth transition so as to not introduce blocking artifacts */
for chan = 1:C
    st.e(st.frame_size+1:N, chan) = (st.window(st.frame_size+1:N) .* st.e(st.frame_size+1:N, chan)) + (st.window(1:st.frame_size) .* st.y(st.frame_size+1:N, chan));
end
else
    reset_background=0;
% Otherwise, check if the background filter is significantly worse */

if (-(Sff-See)*abs(Sff-See)> VAR_BACKTRACK*(Sff*Dbf))
    reset_background = 1;
end
if ((-st.Davg1 * abs(st.Davg1))> (VAR_BACKTRACK*st.Dvar1))
    reset_background = 1;
end
if ((-st.Davg2* abs(st.Davg2))> (VAR_BACKTRACK*st.Dvar2))
    reset_background = 1;
end

if (reset_background)

% Copy foreground filter to background filter */
    st.W = st.foreground;

% We also need to copy the output so as to get correct adaptation */
for chan = 1:C
    st.y(st.frame_size+1:N, chan) = st.e(st.frame_size+1:N, chan);
    st.e(1:st.frame_size, chan) = st.input(:, chan) - st.y(st.frame_size+1:N, chan);
end

See = Sff;
st.Davg1 = 0;
st.Davg2 = 0;
st.Dvar1 = 0;
st.Dvar2 = 0;
end
end